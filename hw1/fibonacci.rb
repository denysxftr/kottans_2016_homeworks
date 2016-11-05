class Fibonacci
  include Enumerable

  def initialize(count)
    @sequence = count.times.map { 1 }
  end

  def each
    k = 0

    until k == @sequence.size
      @sequence[k] = @sequence[k-1] + @sequence[k-2] if k >= 2
      yield(@sequence[k])

      k += 1
    end
    self
  end
end
