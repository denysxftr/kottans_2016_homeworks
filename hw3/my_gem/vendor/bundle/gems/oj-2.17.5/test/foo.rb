#!/usr/bin/env ruby
# encoding: UTF-8

$VERBOSE = true

here = File.expand_path(File.dirname(__FILE__))
$: << File.dirname(__FILE__)
$: << File.join(File.dirname(here), 'ext')
$: << File.join(File.dirname(here), 'lib')

require 'oj'

Oj.mimic_JSON()

class Foo
  def as_json
    { foo: 'bar' }
  end
end

opts = {}

puts Foo.new.to_json
puts Foo.new.to_json(opts)
