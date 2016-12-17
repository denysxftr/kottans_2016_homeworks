module SimpleRouter
  class Router
    def call(env)
      find_route(env).call(env)
    end

    private

    def initialize(&block)
      @routes = []
      instance_exec(&block)
    end

    def find_route(env)
      @routes.each do |route|
        if env['REQUEST_METHOD'] == route[:method] && env['REQUEST_PATH'] =~ route[:regexp]
          env['router.params'] = extract_params(route[:pattern], env['REQUEST_PATH'])
          return route[:app]
        end
      end
      return ->(_env) { [404, {}, ['not found']] }
    end

    def get(path, rack_app)
      match('GET', path, rack_app)
    end

    def post(path, rack_app)
      match('POST', path, rack_app)
    end

    def match(http_method, path, rack_app)
      rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
      @routes << {
        pattern: path,
        app: rack_app,
        regexp: path_to_regexp(path),
        method: http_method
      }
    end

    def get_controller_action(str)
      controller_name, action_name = str.split('#')
      controller_name = to_upper_camel_case(controller_name)
      Kernel.const_get("#{controller_name}").send(:action, action_name)
    end

    def to_upper_camel_case(str)
      str
        .split('/')
        .map { |part| part.split('_').map(&:capitalize).join }
        .join('::') + 'Controller'
    end

    def path_to_regexp(path)
      Regexp.new('\A' + path.gsub(/:[\w-]+/, '[\w-]+') + '\Z')
    end

    def extract_params(pattern, path)
      pattern
          .split('/')
          .zip(path.split('/'))
          .reject { |e| e.first == e.last }
          .map { |e| [e.first[1..-1], e.last] }
          .to_h
    end
  end
end
