class Fibonacci
  include Enumerable
  def initialize lenght
    @lenght = lenght
  end
  def each &block
    @results = []
    sum = 1
    for i in 0..(@lenght-1)
      @results << sum
      sum = @results[i] + ((i - 1 >= 0) ? @results[i - 1] : 0)
      yield @results[i]
    end
  end
end
