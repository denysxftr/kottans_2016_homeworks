class TestsController < Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Hello from test action, request method #{request.request_method}")
  end

  def index
    response(:text, "Hello from root")
  end
end