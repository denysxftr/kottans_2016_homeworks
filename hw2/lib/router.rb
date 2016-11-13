# Main class for routing our requests
class Router
  def call(env)
    call_right_page(@routes, env['REQUEST_METHOD'], env['REQUEST_PATH'], env)
    # if @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']]
    #   @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)
    # elsif env['REQUEST_PATH'].include?('post')
    #   post_with_name(env['REQUEST_METHOD'], env['REQUEST_PATH'])
    # else
    #   render_missing_page
    # end
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

  def render_missing_page
    [404, {}, ['page not found']]
  end

  def post_with_name(http_method, path)
    if !path[6].nil?
      array = []
      (6...path.size).each do |letter_index|
        array << path[letter_index]
      end
      post_link = array.join
      @routes[http_method][post_link] = [200, {}, ['post ' + post_link]]
    else
      render_missing_page
    end
  end

  def call_right_page(route, method, path, env)
    if route[method][path]
      route[method][path].call(env)
    elsif path.include?('post')
      post_with_name(method, path)
    else
      render_missing_page
    end
  end
end
