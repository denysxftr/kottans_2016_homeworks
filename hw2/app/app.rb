Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
  get '/post/:name', ->(env) { [200, {}, ['post show page']] }
  get '/blog/:page_id/posts/:post_id', lambda do |env|
    [200, {}, ["get blog page: #{env[request_symbols][page_id]} post: #{env[request_symbols][post_id]}"]]
  end
end
