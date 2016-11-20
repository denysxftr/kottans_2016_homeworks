module Asdetmin
  class Controller
    RESPONSE_TYPES = {
        text: ['text/plain', -> (content) { content.to_s }], # converts content to string if it isn't string
        # text/plain is data type
        json: ['application/json', -> (content) { Oj.dump(content) }]
    }.freeze # make hash impossible to changing

    def call(env)
      @env = env                        # posts?title=about_ruby&description=I+love+Ruby
      @request = Rack::Request.new(env) # helps to work with env as with hash # #<Rack::Request:0x0056209b1d32f8>
      # merge: transforms data to hash, a.merge!(a: 'first', b: 'second') => {a: 'first', b: 'second'}
      @request.params.merge!(env['router.params'] || {})
      send(@action_name) # 'show' or 'test' from example
      [200, @response_headers, [@response_body]] # returns data of chosen action
    end

    def self.action(action_name) # receives @action_name from send(@action_name)
      proc { |env| new(action_name).call(env)} # calls action by passed name
    end

    private
    attr_reader :request # to apply request instance

    def initialize(action_name)
      @action_name = action_name
    end

    def params
      request.params
    end

    def response(type, content)
      @response_headers ||= {} # by default this is empty hash
      # RESPONSE_TYPES[type] looks for according type in RESPONSE_TYPES hash
      # If passed argument (type) was text, it looks for text key and ignore json key
      # RESPONSE_TYPES[type][0] looks for first element in text array that also is key of RESPONSE_TYPES hash
      @response_headers.merge!('Content-Type' => RESPONSE_TYPES[type][0]) # { 'Content-Type': 'text/plain' }
      # Fore example, if type argument is json, it looks for second element in json array that is key of RESPONSE TYPES
      @response_body = RESPONSE_TYPES[type][1].call(content)             # posts: [{id: 1, title: 'lol'}, ...]
    end
  end
end