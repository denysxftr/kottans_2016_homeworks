class Router
  def call(env)
    find_route(env).call(env)
  end

private

  def initialize(&block)
    @routes = []
    instance_exec(&block)
  end

  def find_route(env)
    # puts "call find_route #{@routes}"
    @routes.each do |route|
      # puts "#{env['REQUEST_METHOD']} ||||| #{route[:method]} ||||| #{env['REQUEST_PATH']} 
      # |||| #{route[:regexp]}"
      if env['REQUEST_METHOD'] == route[:method] && env['REQUEST_PATH'] =~ route[:regexp]
        # puts "return true if REQUEST_METHOD == method"
        env['router.params'] = extract_params(route[:pattern], env['REQUEST_PATH'])
        return route[:app]
      end
    end

    return ->(_env) { [404, {}, ['not found']] }
  end


  def path_to_regexp(path)
    Regexp.new('\A' + path.gsub(/:[\w-]+/, '[\w-]+') + '\Z')
  end

  def extract_params(pattern, path)
    pattern
      .split('/')
      .zip(path.split('/'))
      .reject { |e| e.first == e.last }
      .map { |e| [e.first[1..-1], e.last] }
      .to_h
  end

  def match(http_method, path, rack_app)
    # puts "call match"
    @routes << { pattern: path, app: rack_app, regexp: path_to_regexp(path), method: http_method }
  end

  def get(path, rack_app)
    # puts "call get"
    match('GET', path, rack_app)
  end

  def post(path, rack_app)
    # puts "call post"
    match('POST', path, rack_app)
  end

end
