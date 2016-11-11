Application = Router.new do
  get '/post/:name', ->(headers) { [200, headers, ['get post show page']] }
  get '/test',       ->(headers) { [200, headers, ['get test']] }
  post '/test',      ->(headers) { [200, headers, ['post test']] }
end
