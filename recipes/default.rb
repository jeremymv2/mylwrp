#
# Cookbook Name:: mylwrp
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# we use resource namespacing to create unique resource names and 
# avoid the infamous Chef 3694 warning
# https://github.com/chef/chef-rfc/issues/76

mylwrp_mything 'mylwrp_add_myfile321' do
  path node['mylwrp']['path']
  size node['mylwrp']['size']
end

mylwrp_mything 'mylwrwp_remove_myfile321' do
  path node['mylwrp']['path']
  action :remove
end
