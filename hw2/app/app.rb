class TestController < Controller #inherit Controller class
  def show  # method show for return params
    response(:json, params)
  end

  def test # method test for return request method
    response(:text, "Request method: #{request.request_method}") # params = "Request method: #{request.request_method}",
  end
end

Application = Router.new do # create new instance of Router

  # get '/test', ->(env) { [200, {}, ['get test']] }
  # post '/test', ->(env) { [200, {}, ['post test']] }

  get '/post/:name/:other_one', 'test#show'
  get '/test', 'test#test' # "#{request.request_method} = get"

  #get '/users/:id', ->(env) { [200, {}, ['post /users/:id']] }
  # get '/users/:id/comments/:comment/rating/:rating', ->(env) { [200, {}, ['post with users comment rating']] }
  # get '/users/articles/:title', ->(env) { [200, {}, ['post with user articles title']] }

end
