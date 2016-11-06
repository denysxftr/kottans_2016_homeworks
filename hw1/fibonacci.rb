class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each(&block)
    @sequence = []
    for i in 1..@length
      if i < 3
        @sequence[i] = 1
      else
        @sequence[i] = @sequence[i - 1] + @sequence[i - 2]
      end
      yield @sequence[i]
    end
  end
end

