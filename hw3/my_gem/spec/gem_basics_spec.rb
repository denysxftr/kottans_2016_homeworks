require 'spec_helper'

RSpec.describe 'Config folder' do
  xit 'has config.ru file' do
    expect(require './config/config.ru').not_to be nil
  end

  it 'has collect.rb file' do
    expect(require './config/collect.rb').not_to be nil
  end
end

RSpec.describe 'App folder' do
  it 'has our main app.rb file' do
    expect(require './app/app.rb').not_to be nil
  end
end
