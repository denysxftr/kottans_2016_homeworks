class Fibonacci

  include Enumerable

  def initialize(num)
    @num = num
  end

  def each
    fib_prev = 0
    fib_curr = 1
    @num.times do
      yield fib_curr
      temp = fib_curr
      fib_curr = fib_curr + fib_prev
      fib_prev = temp
    end
  end
end
