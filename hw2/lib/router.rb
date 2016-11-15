class Router
  def call(env)
    @routes[env['REQUEST_METHOD']].each do |path_pattern, rack_app|
      return rack_app.call(env) if path_pattern.match(env['REQUEST_PATH'])
    end
    [404, {}, ['Not Found']]
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
    @routes[http_method][pattern(path)] = rack_app
  end

  def pattern(path)
    Regexp.new("^#{path.gsub(/:\w+/, '\w+')}\/?$")
  end
end
