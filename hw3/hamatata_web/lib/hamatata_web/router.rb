module HamatataWeb
  class Router
    def call(env)
      req_path, req_method = env['REQUEST_PATH'], env['REQUEST_METHOD']
      lambda_to_call = nil
      @routes.each do |route|
        lambda_to_call = route[:app] if route[:path_regexp].match(req_path) && route[:method] == req_method
      end
      lambda_to_call.nil? ? [404, {}, ['not found']] : lambda_to_call.call(env)
    end

    private

    def initialize(&block)
      @routes = []
      instance_exec(&block)
    end

    %w(get post put delete).each do |http_method|
      define_method http_method do |path, rack_app|
        match(http_method.upcase, path, rack_app) # sends: 'GET', '/posts', lambda
      end
    end

    def match(http_method, path, rack_app)
      rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
      new_obj = {
          method: http_method,
          path: path,
          app: rack_app,
          path_regexp: reg_exp_for_path(path)
      }
      @routes.push(new_obj)
    end

    def get_controller_action(str)
      controller_name, action_name = str.split('#')
      controller_name = to_upper_camel_case(controller_name)
      Kernel.const_get(controller_name).send(:action, action_name)
    end

    def to_upper_camel_case(str)
      str.split('/').map { |part| part.split('_').map(&:capitalize).join }.join('::') + 'Controller'
    end

    # converts path from request to regular expression
    def reg_exp_for_path(path)
      Regexp.new('\A' + path.gsub(/:\w+/, '\w+') + '\Z')
    end
  end
end