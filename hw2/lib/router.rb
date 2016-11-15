class Router
  def call(env)
    @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
	  if Regexp.new == env['REQUEST_PATH']
	else
	  return ->(env) { [404, {}, ['Not found']] }
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

  def new_path(path)
    Regexp.new(path.gsub(/:[a-zA-Z0-9_]+/))


  def match(http_method, path, rack_app)
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
	end
  end
end
