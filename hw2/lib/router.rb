class Router
  def call(env)
    request_method = env['REQUEST_METHOD']
    request_path = env['REQUEST_PATH']
    routes = @routes[request_method][request_path]

    if routes
      routes.call(env)
    elsif request_path.match(/\/post\/(\d+|\w+)/)
      match(request_method, request_path, ->(env) { [200, {}, ['post show page']] })
      @routes[request_method][request_path].call(env)
    else
      [404, {}, ['Not Found']]
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
