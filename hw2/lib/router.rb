class Router
  NOT_FOUND = ->(env) { [404, {}, ['not found']] }

  def call(env)
    @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
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
    @routes[http_method] ||= Hash.new(NOT_FOUND)
    @routes[http_method][path] = rack_app
  end
end
