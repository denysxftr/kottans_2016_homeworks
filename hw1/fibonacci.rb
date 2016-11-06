class Fibonacci
  include Enumerable

  def initialize(number)
    validate(number)
    @n = number
  end

  def each(&block)
    a = 1
    b = 0
    (1..@n).each do |i|
      if i == 1
        block.call(1)
      else
        block.call(a + b)
        b, a = a, a + b
      end
    end
  end

  def validate(number)
    raise ArgumentError unless number.is_a?(Integer) && number >=0
  end
end
