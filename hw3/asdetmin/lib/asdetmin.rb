require "asdetmin/version"

module Asdetmin
  class Router
    def call(env)
      [200, { "Content-Type" => "text/html" }, ["Hello"]]
    end
  end
end
