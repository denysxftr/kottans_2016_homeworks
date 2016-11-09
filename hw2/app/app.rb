Application = Router.new do
  get '/test', ->(_) { [200, {}, ['get test']] }
  post '/test', ->(_) { [200, {}, ['post test']] }
end
