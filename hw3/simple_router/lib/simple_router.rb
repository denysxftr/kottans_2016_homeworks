require 'rack'
require 'oj'
require 'simple_router/version'
require 'simple_router/router'
require 'simple_router/controller'

module SimpleRouter
  class TestsController < Controller
    def show
      response(:json, params)
    end

    def test
      response(:text, "Request method: #{request.request_method}")
    end
  end

  Application = Router.new do
    get '/post/:name/:other_name', 'tests#show'
    get '/test', 'tests#test'
  end
end
