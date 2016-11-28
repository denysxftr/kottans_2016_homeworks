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
