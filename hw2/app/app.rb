Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }

  get '/sergey/:family_name', ->(env) { [200, {}, ["Hello Sergey #{env['params']['family_name']}"]] }

  get '/post/:name/article/:id', ->(env) { [200, {}, ["get post #{env['params']['name']} and article #{env['params']['id']}"]] }
  get  '/post/:name', ->(env) { [200, {}, ["get post with name #{env['params']['name']}"]] }
end
