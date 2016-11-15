Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/post/:name', -> (env) {[200, {}, ['show post page']]}
  get '/some/:id/other/:id', -> (env) {[200, {}, ['some other path']]}
end
