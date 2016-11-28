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
end
