class Router
  def call(env)
    find_route(env).call(env)
  end

private

  def initialize(&block)
    @routes = []
    instance_exec(&block)
  end

  def find_route(env)
    @routes.each do |route|
      if env['REQUEST_METHOD'] == route[:method] && env['REQUEST_PATH'] =~ route[:regexp]
        return route[:app]
      end
    end

    ->(_env) { [404, {}, ['page not found']] }
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    @routes <<  { 
      method: http_method, 
      pattern: path, 
      app: rack_app,
      regexp: path_to_regexp(path)
    }
  end

private

  def path_to_regexp(path)
    Regexp.new('\A' + path.gsub(/:[\w-]+/, '[\w-]+') + '\Z')
  end
end
