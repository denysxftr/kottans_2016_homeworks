class TestsController < Hw3::Controller
  def index
    erb = ERB.new('<h2>Kottans HWks stuff</h2><p>Time now: <%= Time.now %></p>')
    response(:erb, erb)
  end

  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end

Application = Hw3::Router.new do
  get '/show/:some/:params', 'tests#show'
  get '/haha', 'tests#test'
  get '/', 'tests#index'
end
