require 'my_gem/version'
##
# Controller (inherit from our main Controller class)
#
class TestsController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Request method: #{request.request_method}")
  end
end

##
# Router (just create Route.new from our main Route class)
#

MyApp = Router.new do
  get '/test', 'tests#test'
  get '/post/:name', 'tests#show'
end

##
# End of our application.rb file
#
