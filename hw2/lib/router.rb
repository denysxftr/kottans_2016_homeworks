class Router
  def call(env)
    select_route(env).call(env)
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
    @routes[http_method][regexp_method(path)] = {
      :app => rack_app,
      :pattern => path
    }
  end

  def regexp_method(path) 
    Regexp.new(path.gsub(/:[a-zA-Z0-9_]+/, '[a-zA-Z0-9_]+'))
  end

  def select_route(env) 
    @routes[env['REQUEST_METHOD']].each do |path_regexp, route|
      if env['REQUEST_PATH'] =~ path_regexp
        return route[:app]
      end
    end
    return ->(env) {[404, {}, ['Page not found']]}
  end 
end