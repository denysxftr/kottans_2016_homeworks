Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/var/:id', ->(env) { [200, {}, ['get test with variable']] }
  post '/var/:id', ->(env) { [200, {}, ['post test with variable']] }
  get '/var1/:id1/var2/:id2', ->(env) { [200, {}, ['get test with two variables']] }
  post '/var1/:id1/var2/:id2', ->(env) { [200, {}, ['post test with two variables']] }
end
