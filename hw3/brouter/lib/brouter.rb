require 'brouter/version'
require 'rack'
require 'oj'

module Brouter
  require 'controller'

  class Router
    NotFound = ->(env) { [404, {}, ['not found']] }

    def call(env)
      find_route(env).call(env)
    end

    private

    def initialize(&block)
      @routes = {}
      instance_exec(&block)
    end

    [:get, :post, :patch, :delete].each do |method_name|
      define_method method_name do |path, rack_app|
        match(method_name.to_s.upcase, path, rack_app)
      end
    end

    def match(http_method, path, rack_app)
      @routes[http_method] ||= {}
      @routes[http_method][path] = [rack_app]
    end

    def find_route(env)
      routes_req_method = @routes.fetch(env['REQUEST_METHOD'], NotFound)
      return NotFound if routes_req_method == NotFound # return 404 if there's no such method

      path = env['REQUEST_PATH']
      return routes_req_method[path].first if routes_req_method[path].is_a?(Proc) # return app if the route is simple (without pattern)

      rack_app = process_path(routes_req_method, path)
      return get_controller_action(rack_app) if rack_app.is_a?(String) # call respective controller if needed
      rack_app # return app for patterned route or 404 if there is no such route
    end

    def process_path(routes_req_method, env_path)
      env_path_array = env_path.split('/')

      routes_req_method.each do |path, array| # starting to check if each part of the path matches present patterns in the routes

        path_array = path.split('/')

        if env_path_array.length == path_array.length # the path doesn't match if its length differs from the pattern's one
          route_exists = false
          params_hash = {} # save each param if env_path responds to route with pattern


          for i in 1...path_array.length  # counting from 1 because the first el in the array is an empty string

            part = path_array[i]
            if part[0] == ':' or part == env_path_array[i]
              route_exists = true

              params_hash[part] = env_path_array[i] if part[0] == ':' # save params if there are some
            else # break the iteration if path parts don't match with each other
              route_exists = false
              break
            end
          end

          array << params_hash unless params_hash.empty? # add params to @routes
          return array[0] if route_exists
        end

      end

      NotFound
    end

    def get_controller_action(controller_and_action)
      return NotFound if controller_and_action !~ /\w+#\w+/

      controller_name, action_name = controller_and_action.split('#')
      controller_name = controller_name
                            .split('/')
                            .map { |word| word.split('_').map(&:capitalize).join }
                            .join('::') + 'Controller'
      Object.const_get(controller_name).send(:action, action_name)
    end
  end
end
