class Router
  def call(env)
    find_route(env).call(env)
  end

  def find_route(env)
    path = env["PATH_INFO"]
    http_method = env["REQUEST_METHOD"]
    routes_list = @routes[http_method]
    routes_list.each do |k, v|
      if path == k || path =~ regexp_match(k)
       return v
      end
    end
    return ->(env) { [404, {}, ['not found']] }
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

  def regexp_match(path)
    Regexp.new("^#{path.gsub(/:\w+/, '\w+')}\/?$")
  end

  def match(http_method, path, rack_app)
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
  end
end
