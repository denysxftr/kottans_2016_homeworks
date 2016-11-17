class Router
  def call(env)
    if @routes[env['REQUEST_METHOD']] && @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']]
      return @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
    end

    # 404 error page
    [404, {}, ['Page not found']]
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
