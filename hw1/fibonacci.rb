class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    prev = 0
    current = 1
    @length.times do 
      yield current
      current, prev = (current + prev), current
    end
  end
end
