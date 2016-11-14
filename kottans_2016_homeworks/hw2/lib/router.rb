class Router
  def call(env)
    route_for(env)
  end


  def reg_path(path)
    Regexp.new("^#{path.gsub(/(:\w+){1,}/, '\w+')}\/?$")
  end
  

  def route_for(env)
    http_method = env['REQUEST_METHOD']
    url_path = env['REQUEST_PATH']
    get_routes = @routes[http_method]
    .map {|key, val| key if reg_path(key)
    .match(url_path)}
    .reject {|val| val.nil?}
      
      if get_routes.empty?
      return [404, {}, ['404 error']]
      else
      return @routes[http_method][get_routes[0]].call(env)
      end
  
  end


private

  def initialize(&block)
    @routes = {}
    instance_exec(&block)
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
  end



end
