class Controller
  RESPONSE_TYPES = {
      text: { mimetype: 'text/plain',       content: ->(content) { content.to_s } },
      json: { mimetype: 'application/json', content: ->(content) { Oj.dump(content) } }
  }.freeze

  def call(env)
    @env = env
    @request = Rack::Request.new(env)
    @request.params.merge!(env['router.params'] || {})
    send(@action_name)
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

  def response(code, type, content)
    @response_headers ||= {}
    @response_headers.merge!('Content-Type' => RESPONSE_TYPES[type][:mimetype])
    @response_body = [RESPONSE_TYPES[type][:content].call(content)]
    [code, @response_headers, @response_body]
  end
end