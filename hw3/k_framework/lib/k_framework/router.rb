module KFramework
  class Router

    def call(env)
      @routes[env['REQUEST_METHOD']].each do |route|
        env['router.params'] = extract_params(route[:path], env['PATH_INFO'])
        return route[:app].call(env) if route[:pattern].match(env['PATH_INFO'])
      end
      [404, {}, ['not found']]
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
      rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
      @routes[http_method] ||= []
      @routes[http_method] << { pattern: pattern(path), app: rack_app, path: path }
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

    def pattern(path)
      Regexp.new("^#{path.gsub(/:\w+/, '\w+')}\/?$")
    end

    def extract_params(route_path, path_info)
      route_path
        .split('/')
        .zip(path_info.split('/'))
        .reject { |e| e.first == e.last }
        .map { |e| [e.first[1..-1], e.last] }
        .to_h
    end
  end
end
