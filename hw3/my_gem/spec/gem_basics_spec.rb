require 'spec_helper'

##
# Check for folders content
# To be found our required files
#

RSpec.describe 'App folder' do
  it 'has our main app.rb file' do
    expect(File.exist?('./app/application.rb')).to be true
  end

  it 'has config.ru file' do
    expect(File.exist?('./config.ru')).to be true
  end
end

RSpec.describe 'Config folder' do
  it 'has collect.rb file' do
    expect(File.exist?('./config/collect.rb')).to be true
  end
end

RSpec.describe 'Lib folder' do
  it 'has controller.rb file' do
    expect(File.exist?('./lib/controller.rb')).to be true
  end

  it 'has router.rb file' do
    expect(File.exist?('./lib/router.rb')).to be true
  end
end

##
# All files that is needed are in tests
# Tests for files location are done
#
