class Fibonacci

  include Enumerable

  def initialize(n)
    @n = n
  end

  def each
    1.upto(@n) do |i|
      if i == 1
        yield i
      else
        fibo, fibo_prev = 1, 1
        (2...i).each { fibo, fibo_prev = fibo + fibo_prev, fibo }
        yield fibo
      end
    end
  end
end
