Application = Router.new do
  get '/test1',               ->(env) {[200, {}, ['Page 1']]}
  get '/test2/test:id',       ->(env) {[200, {}, ['Page 2']]}
  get '/test3/:id',           ->(env) {[200, {}, ['Page 3']]}
  get '/test4/:id/test5',     ->(env) {[200, {}, ['Page 4']]}
  get '/test4/:id/test5/:id', ->(env) {[200, {}, ['Page 5']]}
end
