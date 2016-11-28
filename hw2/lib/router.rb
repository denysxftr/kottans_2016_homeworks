class Router
  def call(env)

   unless env['REQUEST_PATH'] == "/favicon.ico"
     current_env = ->(env) {[404, {}, ['404']]}

     @routes[env['REQUEST_METHOD']].each { |(key,value)|
       key_to_reg_exp= key.gsub(/(?<=:)[^\/]+(?=($|\/))/,"[a-zA-Z0-9_]+").gsub(/\/:/,"/")
       regular_value = Regexp.new /\A#{key_to_reg_exp}\Z/
       current_env = value if regular_value=~env['REQUEST_PATH']
     }
     current_env.call(env)
   end

  end

private

  def initialize(&block)
    @routes = {}
    instance_exec(&block)
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
