class Router
  HEADERS = { 'Content-Type' => 'text/plain' }.freeze

  def call(env)
    req_method = env['REQUEST_METHOD']
    req_path = env['REQUEST_PATH']
    modify_route(req_method, req_path)
    routes = @routes[req_method][req_path]
    return not_found if routes.nil? || (req_path =~ %r{\A\/\w+\/:name\z})
    routes.call(HEADERS)
  end

  private

  def initialize(&block)
    @routes = {}
    instance_exec(&block)
  end

  def modify_route(req_method, req_path)
    return unless permitted_path?(req_path)
    # TODO: hardcoded to use /:name in path
    path_name = "/#{req_path.split('/')[1]}/:name"
    p path_name
    if !@routes.dig(req_method, path_name).nil?
      @routes[req_method][req_path] = @routes[req_method].delete(path_name)
    else
      @routes[req_method].delete(path_name)
    end
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
  end

  def not_found
    [404, HEADERS, ['Not Found']]
  end

  def permitted_path?(req_path)
    %r{\A\/\w+\/\w+\z} =~ req_path
  end
end
