class TestsController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method ")
  end
end

Application = Router.new do
  get '/test', ->(env) { [200, {}, ['get test']] }
  post '/test', ->(env) { [200, {}, ['post test']] }
end
