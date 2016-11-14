class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    prev, curr = 1, 1

    @length.times do
      yield prev
      prev, curr = curr, curr + prev
    end
  end
end
