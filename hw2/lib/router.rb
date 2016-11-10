class Router
  def call(env)
    if nested_post? env
      @routes[env['REQUEST_METHOD']]['/post/:name'].call(env)
    else
      @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
    end
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
    @routes[http_method] ||= Hash.new(->(env) { [404, {}, ['not found']] })
    @routes[http_method][path] = rack_app
  end

  def nested_post?(env)
    path_arr = env['REQUEST_PATH'][1..-1].split('/')
    env['REQUEST_METHOD'] == 'GET' && path_arr.size == 2 && path_arr[0] == 'post'
  end
end
