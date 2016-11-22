module Asdetmin
  class Router
    def call(env)
      req_path, req_method = env['REQUEST_PATH'], env['REQUEST_METHOD']  # storing request's method and path to variables
      lambda_to_call = nil                              # default value setting to indicate incorrect requests for future
      @routes.each do |route|                                   # iterating through routes array to get interesting route
        # compares paths from route and request path with regular expressions
        # route path in reg exp: posts/\w/comments/\w
        # request path: posts/12/comments/2 will be accepted while verification by reg exp
        lambda_to_call = route[:app] if route[:path_regexp].match(req_path) && route[:method] == req_method
      end

      # calls route's lambda if request's path passed verification by route's reg exp, otherwise shows not found
      lambda_to_call.nil? ? [404, {}, ["Not found :("]] : lambda_to_call.call(env)
    end

    private
    # receives routes lambdas and execute them
    def initialize(&block)
      @routes = []

      instance_exec(&block)
    end

    # matches defined request methods
    %w(get post put delete).each do |http_method|
      define_method http_method do |path, rack_app|
        match(http_method.upcase, path, rack_app) # sends: 'GET', '/posts', lambda
      end
    end

    # stocks methods in routes instance
    def match(http_method, path, rack_app) # receives: 'GET', '/posts', lambda
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
      controller_name, action_name = str.split('#') # tests#show => [tests, show]
      controller_name = to_upper_camel_case(controller_name)
      Kernel.const_get(controller_name).send(:action, action_name) # calls action by it's name
    end

    def to_upper_camel_case(str) # receives controller's name (could be convert to module: public/tests)

      str # 'public_pages/tests'
          .split('/')         # if module exist it splits by ['public_pages', 'tests']
          .map { |part| part.split('_').map(&:capitalize).join } # [['Public', 'Pages'], [Tests]] => ['PublicPages', 'Tests']
          .join('::') + 'Controller' # (['PublicPages', 'Tests'] => PublicPages::Tests) + Controller => PublicPages::TestsController
      # &:capitalize same to  word.map{|part| word.capitalize}
      # join - sticks the words. ['Hello', 'World'] => HelloWorld
    end

    # converts path from request to regular expression
    def reg_exp_for_path(path)
      Regexp.new('\A' + path.gsub(/:\w+/, '\w+') + '\Z')                      # changes /posts/:id to /posts/with-any-word
    end                                                                                      # \w  is same to [a-zA-Z0-9_]
  end
end