# Should be considered a requirement for any
# lightweight resource authored against the 11.0+ versions of the chef-client
# Using this method ensures that the chef-client can notify parent lightweight resources
# after embedded resources have finished processing
use_inline_resources if defined?(use_inline_resources)

# Support "no-operation" mode
def whyrun_supported?
  true
end

def load_current_resource
  # Instantiate and populate our @current_resource object
  # if underscores exist in cookbook/recipe name, they turn into camel case
  @current_resource = Chef::Resource::MylwrpMything.new(@new_resource.name)
  @current_resource.path(@new_resource.path)
  @current_resource.size(@new_resource.size)
  # perform an indempotency check
  Chef::Log.info "Checking to see if resource already exists: '#{ @current_resource }'"
  if check_exists?(@current_resource.path)
    # set our 'exists' attribute since the file exists, therefore resource exists
    @current_resource.exists = true
    # note: you could also set other @current_resource properties, for ex. from the registry
  end
  # return the @current_resource object, not required but a good practice
  @current_resource
end

action :add do
  # check condition
  unless @current_resource.exists
    # use converge_by for whyrun mode
    converge_by("Adding new #{ @current_resource }") do
      # run the shell script installer, passing in our cool attribute integer
      create(@current_resource)
      # this is redundant (handled automatically by converge_by), but useful for clarity
      @new_resource.updated_by_last_action(true)
    end
  else
    # this kind of message is helpful in client runs
    Chef::Log.warn("#{ @new_resource } already exists -- action will be skipped.")
  end
end

action :remove do
  # pretty much same as :add with reverse logic
  if @current_resource.exists
    converge_by("Removing #{ @current_resource }") do
      delete(@current_resource)
      @new_resource.updated_by_last_action(true)
    end
  else
    Chef::Log.warn("#{ @new_resource } doesn't exist -- can't remove.")
  end
end

private

def create(it)
  bash 'make_it_so' do
    cwd ::File.dirname('/tmp')
     code <<-EOH
       dd if=/dev/zero of=#{it.path} bs=1k count=#{it.size}
     EOH
  end
end

def delete(it)
  bash 'remove_it' do
    cwd ::File.dirname('/tmp')
     code <<-EOH
       rm -f #{it.path}
     EOH
  end
end

# Check if updates need to be executed
def check_exists?(path)
  # This can also be accomplished with ::File.exists? however, this demonstrates how a more complex shellout
  # command can be used to determine state
  #cmd = shell_out("ls #{path}", { :returns => [0,1,2] })
  #cmd.stderr.empty? && (cmd.stdout !~ /^$/)
  ::File.exist?(path)
end
