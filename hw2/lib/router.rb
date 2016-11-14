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
    match(:GET, path, rack_app)
  end

  def post(path, rack_app)
    match(:POST, path, rack_app)
  end

  def match(method, path, rack_app)
    @routes[method] ||= {}
    @routes[method][path_to_regexp(path)] = {
      pattern: path,
      app: rack_app
    }
  end

  def select_route(env)
    @routes[env['REQUEST_METHOD'].to_sym] &&
    @routes[env['REQUEST_METHOD'].to_sym]
    .each do |path_regexp, route|
      if env['REQUEST_PATH'] =~ path_regexp
        env['params'] = get_params(route[:pattern], env['REQUEST_PATH'])
        return route[:app]
      end
    end
    return ->(env) { [404, {}, ['Not found']] }
  end

  def path_to_regexp(path)
    Regexp.new(path.gsub(/:[a-zA-Z0-9_]+/, '[a-zA-Z0-9_]+'))
  end

  def get_params(pattern, path)
    pattern
      .split('/')
      .zip(path.split('/'))
      .reject { |e| e.first == e.last }
      .map { |e| [e.first[1..-1], e.last] }
      .to_h
  end
end
