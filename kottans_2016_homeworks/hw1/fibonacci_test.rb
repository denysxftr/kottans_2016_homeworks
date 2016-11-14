require './hw1/fibonacci'

def assert(expect:, to_equal: true, text:)
  if expect == to_equal
    puts "\e[32m#{text}: OK!\e[0m"
  else
    puts "\e[31m#{text}: FAILED!\e[0m"
    puts "Expected: #{expect.inspect}"
    puts "To equal: #{to_equal.inspect}"
    exit(1)
  end
end

assert(
  expect: defined?(Fibonacci),
  to_equal: 'constant',
  text: 'class defined'
)

sequence = Fibonacci.new(1)
puts sequence.map(&:to_s)
assert(
  expect: sequence.methods.include?(:each),
  text: 'has method each'
)

assert(
  expect: Fibonacci.ancestors.include?(Enumerable),
  text: 'has enumerable included'
)

assert(
  expect: sequence.map(&:to_s),
  to_equal: ["1"],
  text: 'map works for one element'
)

sequence = Fibonacci.new(10)
assert(
  expect: sequence.map(&:to_s),
  to_equal: ["1", "1", "2", "3", "5", "8", "13", "21", "34", "55"],
  text: 'map works for many elements'
)
