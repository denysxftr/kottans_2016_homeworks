class Router
  def call(env)
    route = @routes[env['REQUEST_METHOD']].find { |k, _v| env['REQUEST_PATH'] =~ k }
    return halt_with(404, 'not found', env) if route.nil?
    route[1].call(env)
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
    pattern = prepare_match_pattern(path)
    @routes[http_method] ||= {}
    @routes[http_method][pattern] = rack_app
  end

  def prepare_match_pattern(path)
    return %r{^\/post\/[\w\d]+$} if path =~ %r{^\/post\/:.+$}
    /#{Regexp.quote(path)}/
  end

  def halt_with(code, body, env)
    ->(_env) { [code, {}, [body]] }.call(env)
  end
end
