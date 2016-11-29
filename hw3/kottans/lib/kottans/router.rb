class Router

  def call(env)
    tmp_hsh = @routes[env['REQUEST_METHOD']].select do |k, v|
      @patterns[k] === env['REQUEST_PATH']
    end
    tmp_hsh.values.first.call(env)
  rescue
    not_found
  end

  private

  def initialize(&block)
    @routes, @patterns = {}, {}
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
    @routes[http_method] ||= {}
    @routes[http_method][path] = rack_app
    @patterns[path] ||= build_reg(path)
  end

  def not_found
    [404, {}, ['Not found']] 
  end

  def build_reg(path)
    reg = path.split('/').each { |v| v.gsub!(/:\w+/, '\w+') }.join('/') << '$'
    Regexp.new(reg)
  end

  def get_controller_action(str)
    controller_name, action_name = str.split('#') # tests#show => ['tests', 'show']
    controller_name = to_upper_camel_case(controller_name)
    Kernel.const_get(controller_name).send(:action, action_name)
    # controller_name = public_test
    # action_name = show
    # PublicTestController.action('show')
  end

  def to_upper_camel_case(str)
    str # 'public_pages/tests' => PublicPages::TestsController
      .split('/') # ['public_pages', 'test']
      .map { |part| part.split('_').map(&:capitalize).join } # ['PublicPages', 'Test']
      .join('::') + 'Controller'
  end
end
