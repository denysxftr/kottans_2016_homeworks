Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }

  get '/posts/:id/edit', ->(env) do
    [200, {}, ["Post #{env['PARAMS'][:id]}"]]
  end
end
