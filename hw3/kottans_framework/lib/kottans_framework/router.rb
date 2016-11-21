module KottansFramework
  class Router
    def call(env)
      route_regexp, action = @routes[env['REQUEST_METHOD']].detect do |(key, _value)|
        key =~ env['REQUEST_PATH']
      end
      if action
        env['router.params'] = parse_params(route_regexp, env['REQUEST_PATH'])
        action.call(env)
      else
        page_not_found.call(env)
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
      @routes[http_method][path_regexp(path)] = rack_app
    end

    def page_not_found
      ->(env) { [404, {}, ['Page not found']] }
    end

    def path_regexp(path)
      path = path.gsub(/:(\w+)/, '(?<\1>[\w-]+)')
      Regexp.new("\\A#{path}\\Z")
    end

    def parse_params(route_regexp, request_path)
      data = route_regexp.match(request_path)
      data.names.zip(data.captures).to_h
    end
  end
end
