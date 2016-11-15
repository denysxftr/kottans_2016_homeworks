Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
else
  post '/', ->(env) { [404, {}, ['not found']] }
end
