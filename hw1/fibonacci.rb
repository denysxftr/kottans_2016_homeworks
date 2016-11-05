class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    a, b = 1, 1
    @length.times do
      yield a
      a, b = b, a+b
    end
  end
end
