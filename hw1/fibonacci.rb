class Fibonacci
  include Enumerable

  def initialize(sequence_size)
    @sequence_size = sequence_size
  end

  def each
    fib1 = 1
    fib2 = 1
    iterable = 0
    loop do
       yield fib1
       fib_sum = fib2+fib1
       fib1 = fib2
       fib2 = fib_sum
       iterable +=1
       break if iterable==@sequence_size
    end
  end

end

