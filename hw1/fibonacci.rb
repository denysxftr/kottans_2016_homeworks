class Fibonacci
  include Enumerable

  attr_reader :size

  def initialize(size)
    @size = size
  end

  def each
    i = 0
    prev = 0
    next_step = 1
    current = 1
    loop do
      yield current
      current = prev + next_step
      prev = next_step
      next_step = current
      i += 1
      break if i == size
    end
  end
end
