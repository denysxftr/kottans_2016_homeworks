class Router
  def call(env)
    env['PARAMS'] = {}
    lamda = nil
    @routes[env['REQUEST_METHOD']].each do |key, value|
      if env['REQUEST_PATH'] =~ key
        lamda = value
        env['PARAMS'] = key.match(env['REQUEST_PATH'])
        break
      end
    end
    lamda = ->(env) { [404, {}, ['Page not found']] } unless lamda
    lamda.call(env)
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
    @routes[http_method][prepare_route_regex(path)] = rack_app
  end

  def prepare_route_regex(path)
    arr = path.split('/')
    temp = arr.map do |e|
      if e[0] == ':'
        name = e[1..-1]
        "(?<#{name}>\\w+)" 
      else
        e
      end 
    end
    reg_str = "^#{temp.join('\/')}$"
    Regexp.new(reg_str)
  end
end
