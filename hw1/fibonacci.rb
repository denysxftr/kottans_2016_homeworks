class Fibonacci

  include Enumerable

  def initialize(n)
    @sequence = []
    (1..n).each { |i| @sequence << fibonacci(i) }
  end

  def each
    0.upto(@sequence.length - 1) { |x| yield @sequence[x] }
  end

  private

  def fibonacci(n)
    n <= 1 ? n : fibonacci(n - 1) + fibonacci(n - 2)
  end
end
