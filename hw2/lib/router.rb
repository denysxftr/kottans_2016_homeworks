class Router
  NotFound = ->(env) { [404, {}, ['not found']] }

  def call(env)
    routes_req_method = @routes.fetch(env['REQUEST_METHOD'], NotFound)
    if routes_req_method == NotFound
      NotFound.call(env)
    else
      path = env['REQUEST_PATH']
      routes_req_method.fetch(path, check_pattern(routes_req_method, path)).call(env)
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
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
  end

  def check_pattern(routes_req_method, env_path)
    env_path_array = env_path.split('/')

    routes_req_method.each do |path, rack_app| # starting to check if each part of the path matches present patterns in the routes
      path_array = path.split('/')

      if env_path_array.length == path_array.length # the path doesn't match if its length differs from the pattern's one

        route_exists = false

        for i in 1...path_array.length # counting from 1 because the first el in the array is an empty string

          if path_array[i][0] == ':' or path_array[i] == env_path_array[i]
            route_exists = true
          else # break the iteration if path parts don't match with each other
            route_exists = false
            break
          end
        end

        return rack_app if route_exists
      end
    end

    NotFound
  end
end
