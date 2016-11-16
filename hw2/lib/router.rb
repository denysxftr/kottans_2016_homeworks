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
end
