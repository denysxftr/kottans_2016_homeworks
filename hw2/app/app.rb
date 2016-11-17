Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/test/:id', ->(env) { [200, {}, ['get test with param']] }
end
