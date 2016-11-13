class Router
  def call(env)
      @routes[env['REQUEST_METHOD']].each do |v|
      return v[:app].call(env) if env['REQUEST_PATH'] =~ v[:pattern]
    end
    [404, {}, ['Not found']]
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
    @routes[http_method].push({ app: rack_app, pattern: to_regexp(path) })
  end

  def to_regexp(path)
    Regexp.new('\A' + path.gsub(/:\w+/, '\w+') + '\Z')
  end
end
