class TestController < MyFramework::Controller
  def test
    response(:text, "Request method: #{request.request_method}")
  end

  def show
    response(:json, params)
  end
end

Application = MyFramework::Router.new do
  get '/test', 'test#test'
  get '/post/:name/:one_more', 'test#show'
end
