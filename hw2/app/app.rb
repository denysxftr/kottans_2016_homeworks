Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
 get '/post/:id', ->(env) { [200, {}, ['post show page']] }
  get '/post', ->(env) { [200, {}, ['post index page']] }
  get '/post/:id/any/:id', ->(env) { [200, {}, ['post any index page']] }
end
