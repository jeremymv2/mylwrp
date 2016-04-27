#
# Cookbook Name:: mylwrp
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'mylwrp::default' do
  let(:chef_run) do
    runner = ChefSpec::SoloRunner.new(step_into: ['mylwrp_mything'])
    runner.converge(described_recipe)
  end

  it 'includes recipe mylwrp::default' do
    expect(chef_run).to include_recipe('mylwrp::default')
  end

  it 'adds a file' do
    expect(chef_run).to add_mylwrp_mything('mylwrp_add_myfile321')
  end

  #it 'removes a file' do
  #  expect(chef_run).to remove_mylwrp_mything('mylwrp_remove_myfile321')
  #end
end
