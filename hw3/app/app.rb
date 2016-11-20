class TestsController < Controller
  def show
    response(:json, params)
  end

  def test 
    response(:text, "Request method: #{request.request_method}")
  end

end

Application = Router.new do
  get '/post/:name', 'tests#show'
  get '/test', 'tests#test'

end
