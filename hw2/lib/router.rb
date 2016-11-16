=begin
@routes[REQUEST_METHOD] has two hashes "simple" and "complex"
"simple"  - to storage routes without ":" "/test/some_path"
"complex"  - to storage routes with ":" "/test/:name

@routes = {
  "GET":
    "simple": {
      "/test": RACK_APP_1
    }
    "complex": {
      "/test/:name": RACK_APP_3
      "/test/:name/:name": RACK_APP_4
    }
  "POST": {
    "simple": {
      "/test": RACK_APP_2
      "/test/some_path": RACK_APP_5
    }
  }
}
=end

class Router
  def call(env)
    current_method, current_path  = env['REQUEST_METHOD'], env['REQUEST_PATH']
    # simple routes handling
    return routes[current_method]['simple'][current_path].call(env) if simple_path?(current_path, current_method)
    # complex routes handling
    path = complex_path?(current_path, current_method)
    return routes[current_method]['complex'][path].call(env) if path
    # 404 routes handling
    ->(env) { [404, {}, ['not found']] }.call(env)
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
    routes[http_method] ||= {}
    routes[http_method]['complex'] ||= {}
    routes[http_method]['simple'] ||= {}

    if path =~ /\/:\w/
      routes[http_method]['complex'][path] = rack_app
    else
      routes[http_method]['simple'][path] = rack_app
    end
  end

  def simple_path?(current_path, current_method)
    routes[current_method]['simple'].keys.each do |path|
      return true if current_path == path
    end

    false
  end

  def complex_path?(current_path, current_method)
    routes[current_method]['complex'].keys.each do |path|
      path_array, current_path_array = path.split('/'), current_path.split('/')
      next if different_path_size?(path_array, current_path_array) || different_pathes?(path_array, current_path_array)

      return path
    end

    nil
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
