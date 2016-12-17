require 'rack'
require 'oj'
require_relative '../lib/simple_router/router'
require_relative '../lib/simple_router/controller'

class TestsController < SimpleRouter::Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end

Application = SimpleRouter::Router.new do
  get '/post/:name/:other_name', 'tests#show'
  get '/test', 'tests#test'
end
