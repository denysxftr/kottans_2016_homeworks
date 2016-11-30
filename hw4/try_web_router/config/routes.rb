ROUTES = Proc.new {
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  put '/test', ->(env) { [200, {}, ['put test']] }
  delete '/test', ->(env) { [200, {}, ['delete test']] }
  get '/posts/:name', 'home#test'
  get '/testing', 'home#show'
  get '/', 'home#root'
}
