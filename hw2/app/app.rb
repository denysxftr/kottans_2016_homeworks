Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  get /posts\/.*/, ->(env) { [200, {}, ['post show page']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
end
