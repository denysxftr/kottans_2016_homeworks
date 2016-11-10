class Router
  def call(env)
    app_for_env(env).call(env)
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

  def patch(path, rack_app)
    match('PATCH', path, rack_app)
  end

  def put(path, rack_app)
    match('PUT', path, rack_app)
  end

  def delete(path, rack_app)
    match('DELETE', path, rack_app)
  end

  def app_for_env(env)
    app = nil
    @routes[env['REQUEST_METHOD']].each do |path|
      unless (path[:regexp] =~ env['REQUEST_PATH']).nil?
        app = path[:app]
        break
      end
    end
    app = ->(_) { [404, {}, ['page not found']] } if app.nil?
    app
  end

  def path_regexp(path)
    parts = path.split('/').map do |part|
      part = part.replace('[A-Za-z0-9_-]+') if part.include? ':'
      part
    end
    Regexp.new('\A' + parts.join('\/') + '\z')
  end

  def match(http_method, path, rack_app)
    @routes[http_method] ||= []
    @routes[http_method] << { regexp: path_regexp(path), app: rack_app }
  end
end
