class Router
  def call(env) 
    res = detect_route(env['REQUEST_METHOD'], env['REQUEST_PATH'])
    if (!res || res.empty?)
      then 
        [404, {}, ['page not found']]
      else 
        env['REQUEST_PATH'] = res
        @routes[env['REQUEST_METHOD']][env['REQUEST_PATH']].call(env)        
    end 
  end

private

  def initialize(&block)
    @routes = {}
    @reserved_words = ["test","users","comments","comments","rating","articles"]
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

  def detect_route(method, path)
    result = nil
    regexp_braced=/^\/(?<test>\/[^()]*\g<test>*\/)?.(\w+)/

    parse_routes(method)

    if(regexp_braced.match(path)) 
      then 
        path_arr = path.split('/')
        path_arr.delete_if{|i| not @reserved_words.include? i}
        @route_arr.each do |key, value|
          if (value.drop(1) == path_arr && path_arr.any?)
            result = path
          end                               
         end
      end
    return result
  end

  def parse_routes(method)
    @route_arr = {}
    @routes[method].each do |key, value|
    @route_arr[key] = key.split('/').delete_if{|i|i.match(/^:/)}
    end
  end
end