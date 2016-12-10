
class ExampleController < Hola::Controller
  def new
    response(:text, "Request method: #{request.request_method}")
  end

  def show
    response(:json, params)
  end

  Application = Hola::Router.new do
    get '/', 'example#new'
    get '/blog/post/:id', 'example#show'
  end
end
