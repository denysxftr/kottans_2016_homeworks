Application = Router.new do
  get '/posts', ->(_) { [200, {}, ['get posts']] }
  get '/posts/:id', ->(_) { [200, {}, ['show post']] }
  post '/posts', ->(_) { [200, {}, ['create post']] }
  patch '/posts/:id', ->(_) { [200, {}, ['update post']] }
  put '/posts/:id', ->(_) { [200, {}, ['update post']] }
  delete '/posts/:id', ->(_) { [200, {}, ['delete post']] }
end
