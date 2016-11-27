class Router
  def call(env) # call method with env params
    find_route(env).call(env) # call env
  end

private

  def initialize(&block) # initialize of code blok
    @routes = [] # set to null @routes
    instance_exec(&block) #call &block
  end

  def find_route(env) # check if route exist
    @routes.each do |route| # in @routes all route
      # check if requst method of call and requst method of route matche
      # and requst path of call math with route path
      if env['REQUEST_METHOD'] == route[:method] && env['REQUEST_PATH'] =~ route[:regexp]
        # if all matches, assing to router.params extract params
        env['router.params'] = extract_params(route[:pattern], env['REQUEST_PATH'])
        return route[:app] # return applocation
      end
    end

    return ->(_env) { [404, {}, ['not found']] } # if not exist return -> 404
  end

  def get(path, rack_app) # get request
    match('GET', path, rack_app)
  end

  def post(path, rack_app) # post request
    match('POST', path, rack_app)
  end

  def match(http_method, path, rack_app) # match
    rack_app = get_controller_action(rack_app) if rack_app.is_a?(String)
    @routes << { pattern: path, app: rack_app, regexp: path_to_regexp(path), method: http_method }
  end

  def get_controller_action(str)
    controller_name, action_name = str.split('#') # tests#show => ['tests', 'show']
    controller_name = to_upper_camel_case(controller_name)# ['tests', 'show'] => ['TestsController', 'show']
    Kernel.const_get(controller_name).send(:action, action_name)
  end

  def to_upper_camel_case(str) # up
    str # 'public_pages/tests' => PublicPages::TestsController
      .split('/') # ['public_pages', 'test']
      .map { |part| part.split('_').map(&:capitalize).join } # ['PublicPages', 'Test']
      .join('::') + 'Controller'
  end


  # /post/:name
  def path_to_regexp(path) # return processing path
    Regexp.new('\A' + path.gsub(/:[\w-]+/, '[\w-]+') + '\Z')
  end

  # /post/:name
  # /post/test_one
  # { name: 'test_one' }
  def extract_params(pattern, path)
    pattern
      .split('/') # ['post', ':name']
      .zip(path.split('/')) # [['post', 'post'],[':name', 'post']]
      .reject { |e| e.first == e.last } # [[':name', 'post']]
      .map { |e| [e.first[1..-1], e.last] } # [['name', 'post']]
      .to_h # { name = > post }
  end
end
