require 'spec_helper'

RSpec.describe 'Config.ru file' do
  xit 'has required main.rb file' do
    expect('./config/config.ru').include "require './config/collect.rb'"
  end

  xit 'and starts application' do
    expect('./config/config.ru').to_have 'run Application'
  end
end
