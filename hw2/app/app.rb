class TestController < Controller
  def test
    response(:text, "Request method: #{request.request_method}")        # request - exemplar of Rack::Request class
                               # we use request method to get the info about request, example: method, path, etc...
  end
end

class PostsController < Controller
  def show
    response(:json, title: params['title'], description: params['description'], author: params['author_name'] )
  end
end

class CommentsController < Controller
  def index
    response(:json, count: params['count'])
  end
end

Application = Router.new do
  get '/test', 'test#test'
  get '/posts/:id', 'posts#show'
  get '/posts/:id/comments', 'comments#index'
end