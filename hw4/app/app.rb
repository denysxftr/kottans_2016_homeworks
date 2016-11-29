Application = Router.new do
  get '/show/:name', 'tests#show'
  get '/test', 'tests#test'
  get '/', 'tests#index'
end
