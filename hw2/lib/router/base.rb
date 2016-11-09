# rubocop:disable Style/Documentation
module Router
  class Base
    def initialize(&block)
      @routes = {}
      instance_exec(&block)
    end

    def call(env)
      (current(env) || not_found).call(env).tap do |rack_app|
        merge_current_params(env, rack_app)
      end
    end

    private

    %i(get post put patch update delete).each do |http_method|
      define_method http_method do |path, rack_app|
        match(http_method.to_s.upcase, path, rack_app)
      end
    end

    def match(http_method, path, rack_app)
      @routes[http_method] ||= {}
      @routes[http_method][main_path path] = rack_app
    end

    def current(env)
      @routes[env['REQUEST_METHOD']][main_path env['REQUEST_PATH']]
    end

    def main_path(path)
      path.split('/')[path.start_with?('/') ? 1 : 0]
    end

    def not_found
      ->(_env) { [404, {}, ['Ooops! We have not found:(']] }
    end

    def merge_current_params(env, rack_app)
      path = env['REQUEST_PATH']
      param = path.split('/')[path.start_with?('/') ? 2 : 1]
      return unless param
      rack_app[1] = rack_app[1].merge('POST_NAME' => param)
    end
  end
end
