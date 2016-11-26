class MyFramework::Router
  def call(env)
    find_route(env).call(env)
  end

  private

  def initialize(&block)
    @routes = {}
    instance_exec(&block)
  end

  def find_route(env)
    if @routes[env['REQUEST_METHOD']]
      return @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']] if @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']]

      @routes[env['REQUEST_METHOD']].each do |routes_path, rack_app|
        next unless routes_path =~ %r{\/:\w} && match_route_to_url?(routes_path, env)
        return rack_app
      end
    end

    # 404 error page
    -> (env) { [404, {}, ['Page not found']] }
  end

  def match_route_to_url?(route, env)
    route_array, url_array = route.split('/'), env['REQUEST_PATH'].split('/')
    return false unless route_array.size == url_array.size
    match_arr = route_array.zip(url_array).reject { |segment| segment[0] == segment[1] }
    match_arr.each { |segment| return false unless segment[0][0] == ':' }
    env['request_vars'] = match_arr.map { |segment| [segment[0][1..-1], segment[1]] }.to_h
    true
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
  end

  def get_controller_action(str)
    controller_name, action_name = str.split('#')
    controller_name = to_upper_camel_case(controller_name)
    Kernel.const_get(controller_name).send(:action, action_name)
  end

  def to_upper_camel_case(str)
    str
      .split('/')
      .map { |part| part.split('_').map(&:capitalize).join }
      .join('::') + 'Controller'
  end
end
