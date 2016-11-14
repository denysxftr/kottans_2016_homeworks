Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }


  get '/post/:post_id/comment/:comment_id', ->(env) { [200, {}, ["Post id: #{env['params']['post_id']}, comment id: #{env['params']['comment_id']}"]] }
  get '/post/:post_id', ->(env) { [200, {}, ["Post id: #{env['params']['post_id']}"]] }

end
