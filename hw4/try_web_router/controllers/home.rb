class HomeController < WebRouter::Controller
  def show
    response(:json, params)
  end

  def test
    response(:text, "Name is: #{params['name']}" )
  end

  def root
    response(:html, erb(:'views/index.html.erb') )
  end
end
