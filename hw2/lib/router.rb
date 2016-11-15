class Router
  def call(env)
    app = @routes[env['REQUEST_METHOD']].find do |el|
      env['REQUEST_PATH'] =~ el[:pattern]
    end
    app ? app[:rack_app].call(env) : [404, {}, ['Not found!']]
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
    @routes[http_method] ||= []
    @routes[http_method] << { pattern: pattern(path) , rack_app: rack_app }
  end

  def pattern(path)
    Regexp.new("^#{path.gsub(/:\w+/, '\w+')}\/?$")
  end
end
