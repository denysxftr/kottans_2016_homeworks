require 'spec_helper'

RSpec.describe 'hw4 app' do
  include Rack::Test::Methods

  def app
    @app ||= Application
  end

  it 'should respond to /test' do
    get '/test'
    expect(last_response.status).to be 200
  end

  it 'test page should return text' do
    get '/test'
    expect(last_response.headers['Content-Type']).to eq 'text/plain'
  end

  it 'test page should return request method' do
    get '/test'
    expect(last_response.body).to eq 'Request method: GET'
  end
end
