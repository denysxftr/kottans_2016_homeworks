Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }

  get '/users/:id', ->(env) { [200, {}, ['post /users/:id']] }
  get '/users/:id/comments/:comment/rating/:rating', ->(env) { [200, {}, ['post with users comment rating']] }
  get '/users/articles/:title', ->(env) { [200, {}, ['post with user articles title']] }
  # get '/', ->(env) { [404, {}, ['page not found']] }
  # get '/test/:id/with/:smth', ->(env) { [200, {}, ['get test with id value']] }
end
