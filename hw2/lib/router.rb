class Router
  def call(env)
    if @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']]
      @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
    else
      if env['REQUEST_PATH'].include?('post')
        match(env['REQUEST_METHOD'], env['REQUEST_PATH'], ->(env) { [200, {}, ['post show page']] })
        @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
      else      
        [404, {}, ['Not Found']]
      end
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
