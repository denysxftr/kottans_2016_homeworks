# Mathes HTTP request to a specific rack app
module Router
  class Base
    def initialize(&block)
      @routes = {}
      instance_exec(&block)
    end

    def call(env)
      current = @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']]
      return not_found.call(env) unless current
      current.call(env)
    end

    private

    %i(get post put patch update delete).each do |http_method|
      define_method http_method do |path, rack_app|
        match(http_method.to_s.upcase, path, rack_app)
      end
    end

    def match(http_method, path, rack_app)
      @routes[http_method] ||= {}
      @routes[http_method][path] = rack_app
    end

    def not_found
      ->(_env) { [404, {}, ['Ooops! We have not found:(']] }
    end
  end
end
