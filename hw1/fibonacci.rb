class Fibonacci

  include Enumerable

  def initialize(num)
    @num = num
  end

  def each
    fib_prev = 1
    fib_cur = 1
    @num.times do |i|
      if i == 1
        yield 1
      else
        yield fib_cur
        fib_cur, fib_prev = (fib_cur + fib_prev), fib_cur
      end
    end
  end

end