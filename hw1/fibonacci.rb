class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    curr, prev = 1, 1
    @length.times do
      yield curr
      curr, prev = prev, curr + prev
    end
  end
end
