class Fibonacci
  include Enumerable

  attr_reader :size

  def initialize(size)
    @size = size
  end

  def each
    i = 0
    n0 = 0
    n1 = 1
    n = 1
    loop do
      yield n
      n = n0 + n1
      n0 = n1
      n1 = n
      i += 1
      break if i == size
    end
  end
end
