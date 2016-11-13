Application = Router.new do
  get '/', ->(env) { [200, {}, ['root path']] }
  post '/', ->(env) { [200, {}, ['root path']] }
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/blog/post/:id', ->(env) { [200, {}, ['post show page']] }
end
