class Fibonacci
  include Enumerable

  def initialize(number)
    validate(number)
    @n = number
  end

  def each(&block)
    curr = 1
    prev = 0
    (1..@n).each do |i|
      block.call(curr)
	    curr, prev = prev + curr, curr     
    end
  end

  def validate(number)
    raise ArgumentError unless number.is_a?(Integer) && number >=0
  end
end
