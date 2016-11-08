# Mathes HTTP request to a specific rack app
module Router
  class Base
    def call(env)
      p env
      @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
    end

    private

    def initialize(&block)
      @routes = {}
      instance_exec(&block)
    end

    %i(get post put patch update delete).each do |http_method|
      define_method http_method do |path, rack_app|
        # Router::Matcher.new(http_method, path, rack_app)
        match(http_method.to_s.upcase, path, rack_app)
      end
    end

    def match(http_method, path, rack_app)
      @routes[http_method] ||= {}
      @routes[http_method][path] = rack_app
    end
  end
end
