class TestController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end

Application = Router.new do
  # get '/test', ->(env) { [200, {}, ['get test']] }
  # post '/test', ->(env) { [200, {}, ['post test']] }
  get '/post/:name/:other_one', 'test#show'
  get '/test', 'test#test'
  #get '/users/:id', ->(env) { [200, {}, ['post /users/:id']] }
  # get '/users/:id/comments/:comment/rating/:rating', ->(env) { [200, {}, ['post with users comment rating']] }
  # get '/users/articles/:title', ->(env) { [200, {}, ['post with user articles title']] }

end
