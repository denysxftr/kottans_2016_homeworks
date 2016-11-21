class Router
  def call(env)

    find_route(env).call(env)
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
    @routes[http_method][create_path_pattern(path)] = rack_app
  end

  def create_path_pattern(path)
    # subpathes_array = path.split('/')
    # subpathes_array.delete_at(0)
    # pattern = ''
    # subpathes_array.each do |element|
    #   pattern << (element.start_with?(':') ? '\/\w+' : '\/' + element)
    # end
    # pattern << '\Z'
    path.gsub(/:[\w-]+/, '[\w-]+')
    path << '\Z'
  end

  def find_route(env)
    @routes[env['REQUEST_METHOD']].each {|path_pattern, value| return value if env['REQUEST_PATH'].match(path_pattern)}
    return ->(env) { [404, {}, ['page not found']] }
  end

end
