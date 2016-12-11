module Hola
  class Controller
    RESPONSE_TYPES = {
      text: ['text/plain', ->(c) { c.to_s }],
      json: ['application/json', ->(c) { Oj.dump(c)} ]
    }.freeze

    def call(env)
      @env = env
      @request = Rack::Request.new(env)
      @request.params.merge!(env['router.params'] || {})
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
end
