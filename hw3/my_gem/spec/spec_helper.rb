$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'rack'
require 'oj'
require './lib/router'
require './lib/controller'
require 'my_gem'
