Application = Router.new do
  # posts
  get     '/posts',                    ->(env) { [200, {}, ['shows the posts'   ]] }             # /posts
  post    '/posts',                    ->(env) { [200, {}, ['creates a post'    ]] }             # /posts
  get     '/posts/:name',              ->(env) { [200, {}, ['shows a post'      ]] }             # /posts/1
  put     '/posts/:name',             ->(env) { [200, {}, ['updates a post'    ]] }             # /posts/1
  delete  '/posts/:name',              ->(env) { [200, {}, ['destroys a post'   ]] }             # /posts/1

  # comments that nested in post
  get     '/posts/:name/comments',     ->(env) { [200, {}, ['shows the comments']] }              # /posts/1/comments
  post    '/posts/:name/comments',    ->(env) { [200, {}, ['creates a comment' ]] }              # /posts/1/comments
  get     '/posts/:name/comments/:id', ->(env) { [200, {}, ['shows a comment'   ]] }              # /posts/1/comments/1
  put     '/posts/:name/comments/:id', ->(env) { [200, {}, ['updates a comment' ]] }              # /posts/1/comments/1
  delete  '/posts/:name/comments/:id', ->(env) { [203, {}, ['destroys a comment']] }              # /posts/1/comments/1
end