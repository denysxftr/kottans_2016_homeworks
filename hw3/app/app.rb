Controller = Controuter::Controller
Router     = Controuter::Router

class TestsController < Controller
  def home
    response(:text, "<h1>Home Page</h1><br><a href='/pages/1'>Page 1</a><br><a href='/pages/2'>Page 2</a>")
  end

  def show
    response(:text, request.path_info)
  end

  def test
    response(:text, "Action 'test'")
  end
end

Application = Router.new do
  get '/',              'tests#home'
  get '/pages/1',       'tests#show'
  get '/pages/2',       'tests#test'
end
