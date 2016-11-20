class TestsController < Hw3::Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end

Application = Hw3::Router.new do
  get '/show/:some/:params', 'tests#show'
  get '/haha', 'tests#test'
end
