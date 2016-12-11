require 'spec_helper'
OUTER_APP = Rack::Builder.parse_file('config.ru').first

RSpec.describe 'hw4 app' do
  include Rack::Test::Methods

  def app
    OUTER_APP
  end

  it 'should respond to /' do
    get '/'
    expect(last_response.status) == 200
  end

  it 'home page should return text' do
    get '/'
    expect(last_response.headers['Content']) == 'text'
  end

  it 'home page should return request method' do
    get '/'
    expect(last_response.body) == ('Request method: GET')
  end
end
