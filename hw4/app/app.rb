require 'simple_f_w'

class TestController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Hello world!")
  end
end

Application = Router.new do
  get '/post/:name/:other_one', 'test#show'
  get '/test', 'test#test'
end
