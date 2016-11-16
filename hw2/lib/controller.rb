class Controller
  RESPONSE_TYPES = {
    text: ['text/plain', ->(c) { c.to_s }],
    json: ['application/json', ->(c) { Oj.dump(c) }]
    }.freeze

  def call(env)
    @env = env
    @request = Rack::Request.new(env)
    @request.params.merge!(env['router.params'] || {})
    show
    [200, @response_headers, @response_body]
  end

  private
  attr_reader :request

  def params
    request.params
  end

  def response(type, content)
    @response_headers ||= {}
    @response_headers.merge!('Content-Type' => RESPONSE_TYPES[type][0])
    @response_body = RESPONSE_TYPES[type][1].call(content)
  end
end
