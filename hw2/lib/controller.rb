class Controller
  RESPONSE_TYPES = { # mini cheat, for work with response
    text: ['text/plain', ->(c) { c.to_s }], # key where stored text params data
    json: ['application/json', ->(c) { Oj.dump(c) }] # key where stored json
  }.freeze # freeze this constant, for avoid random changing

  def call(env) # env standart Rack params
    @env = env # writed env into instance @env
    @request = Rack::Request.new(env) # writed new rack request into instance @request
    @request.params.merge!(env['router.params'] || {}) # merge with router.params if it exist
    send(@action_name) # send @action_name

    [200, @response_headers, [@response_body]] # return array with route
  end

  def self.action(action_name) # call action method for self object, action_name = call method name
    proc { |env| new(action_name).call(env) } # proc create new action and call it
  end

private
  attr_reader :request # create getter for request

  def initialize(action_name) # init with, call method name
    @action_name = action_name # writed action_name into instance @action_name
  end

  def params # params return request params
    request.params
  end

  def response(type, content) #response in header and body
    @response_headers ||= {} # if @response_headers empty assign hash
    @response_headers.merge!('Content-Type' => RESPONSE_TYPES[type][0]) # merge @response_headers with 'Content-Type' => RESPONSE_TYPES[text]['some text']
    @response_body = RESPONSE_TYPES[type][1].call(content) # assign @response_body to RESPONSE_TYPES[json][some json] and call content arguments
  end
end
