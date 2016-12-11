class TestsController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end


Application = Router.new do
  get '/', 'tests#test'
  post '/', 'tests#test'
  get '/test', 'tests#show'
  post '/test', 'tests#test'
  get '/blog/:post/:id', 'tests#show'
end
