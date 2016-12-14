Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/post/:name', ->(env) { [200, {}, ['post show page']] }
end
