class Router

  def call(env)
    @routes.each do |route|
      env['router.params'] = extract_params(route[:path_pattern], env['REQUEST_PATH'])
      return route[:app].call(env) if route[:http_method] == env['REQUEST_METHOD'] && route[:pattern].match(env['REQUEST_PATH'])
    end
    [404, {}, ['Not Found']]
  end

private

  def initialize(&block)
    @routes = []
    instance_exec(&block)
  end

  def get(path, rack_app)
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app)
    rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
    @routes << { http_method: http_method, app: rack_app, path_pattern: path, pattern: pattern(path) }
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

  def pattern(path)
    Regexp.new("^#{path.gsub(/:[\w-]+/, '[\w-]+')}\/?$")
  end

  def extract_params(pattern, path)
    pattern
      .split('/') #['post', ':name']
      .zip(path.split('/')) #[['post', 'post'],[':name', 'post']]
      .reject { |e| e.first == e.last } #[[':name', 'post']]
      .map { |e| [e.first[1..-1], e.last] }
      .to_h
  end

end
