=begin
@routes[REQUEST_METHOD] has two hashes "direct" and "nested"
"direct"  - to storage routes without ":" "/test/some_path"
"nested"  - to storage routes with ":" ""/test/:name""

@routes = {
  "GET":
    "direct": {
      "/test": RACK_APP_1
    }
    "nested": {
      "/test/:name": RACK_APP_3
      "/test/:name/:name": RACK_APP_4
    }
  "POST": {
    "direct": {
      "/test": RACK_APP_2
      "/test/some_path": RACK_APP_5
    }
  }
}
=end

class Router
  def call(env)
    current_method, current_path  = env['REQUEST_METHOD'], env['REQUEST_PATH']

    # direct routes handling
    return routes[current_method]['direct'][current_path].call(env) if direct_path?(current_path, current_method)

    # nested routes handling
    path = nested_path?(current_path, current_method)
    return routes[current_method]['nested'][path].call(env) if path

    # 404 routes handling
    routes[current_method]['404'][current_path].call(env)
  end

private
  attr_reader :routes

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
    routes[http_method] ||= Hash.new { |k,v| k[v] = Hash.new(->(env) { [404, {}, ['not found']] }) }

    if path =~ /\/:\w/
      routes[http_method]['nested'][path] = rack_app
    else
      routes[http_method]['direct'][path] = rack_app
    end
  end

  def direct_path?(current_path, current_method)
    routes[current_method]['direct'].keys.each do |path|
      return true if current_path == path
    end

    false
  end

  def nested_path?(current_path, current_method)
    routes[current_method]['nested'].keys.each do |path|
      path_array, current_path_array = path.split('/'), current_path.split('/')

      next if different_path_size?(path_array, current_path_array) || different_pathes?(path_array, current_path_array)

      return path
    end
  end

  def different_path_size?(path_array, current_path_array)
    path_array.size != current_path_array.size
  end

  def different_pathes?(path_array, current_path_array)
    path_array.each_with_index do |_,index|
      return true unless same_items_of_path?(path_array[index], current_path_array[index])
    end

    false
  end

  def same_items_of_path?(path_item, current_path_item)
    path_item == current_path_item || (path_item =~ /:\w/ && current_path_item =~ /\w/)
  end
end
