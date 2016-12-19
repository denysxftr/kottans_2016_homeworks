# class Router
class Router
  def call(env)
    @routes.each do |route|
      if route[:http_method] == env['REQUEST_METHOD'] &&
         route[:pattern].match(env['REQUEST_PATH'])
        return route[:app].call(env)
      end
    end
    [404, {}, ['Not Found']]
  end

  private

  def initialize(&block)
    @routes = []
    instance_exec(&block)
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    @routes ||= []
    @routes << { http_method: http_method,
                 app: rack_app,
                 path: path,
                 pattern: pattern(path) }
  end

  def pattern(path)
    Regexp.new("^#{path.gsub(/:[\w-]+/, '[\w-]+')}\/?$")
  end
end
