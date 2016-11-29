class Fibonacci
  include Enumerable

  def initialize(limit)
    @fibos = []
    @limit = limit
  end

  def each
    i = 0
    fib1, fib2 = 0, 1
    loop do
      break if i == @limit
      @fibos << yield(fib2) if block_given?
      i += 1
      fib1, fib2 = fib2, fib2 + fib1
    end
  end
end
