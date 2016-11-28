require "controuter/version"

module Controuter

  class Controller
    RESPONSE_TYPES = {
      text: ['text/html', ->(c) { c.to_s }],
      json: ['application/json', ->(c) { Oj.dump(c) }]
    }.freeze

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      #@request.params.merge!(env['router.params'] || {})
      send(@action_name)
      [200, @response_headers, [@response_body]]
    end

    def self.action(action_name)
      proc { |env| new(action_name).call(env) }
    end

  private
    attr_reader :request

    def initialize(action_name)
      @action_name = action_name
    end

    def params
      request.params
    end

    def response(type, content)
      @response_headers ||= {}
      @response_headers.merge!('Content-Type' => RESPONSE_TYPES[type][0])
      @response_body = RESPONSE_TYPES[type][1].call(content)
    end
  end

  class Router
    def call(env)
      find(env)
    end

  private

    def initialize(&block)
      @routes = {}
      instance_exec(&block)
    end

    def find(env)
      current_env = ->(env) {[404, {}, ['404']]}
      @routes[env['REQUEST_METHOD']].each { |(key,value)|
        regular_value =  Regexp.new('\A' + key.gsub(/:[\w-]+/, '[\w-]+') + '\Z')
        current_env = get_controller_action(value) if regular_value=~env['REQUEST_PATH']
      }
      current_env.call(env)
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
  end
end
