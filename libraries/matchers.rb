if defined?(ChefSpec)
  ChefSpec.define_matcher(:mylwrp_mything)

  def add_mylwrp_mything(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:mylwrp_mything, :add, resource)
  end

  def remove_mylwrp_mything(resource)
    ChefSpec::Matchers::ResourceMatcher.new(:mylwrp_mything, :remove, resource)
  end
end
