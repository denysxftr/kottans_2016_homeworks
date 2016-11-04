class Fibonacci
  include Enumerable

  def initialize(index)
    @index = index
  end

  def each
    count = 0
    n = 1
    n1 = 1
    n2 = 0
    loop do
      yield(n)
      n = n1 + n2
      n2 = n1
      n1 = n
      count += 1
      break if count == @index
    end
  end
end
