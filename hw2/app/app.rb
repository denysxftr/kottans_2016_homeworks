Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/test/:id/with/:smth', ->(env) { [200, {}, ['get test with id value']] }
end
