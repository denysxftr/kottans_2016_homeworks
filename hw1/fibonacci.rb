class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    fibs = [1]
    loop do
      yield fibs.last
      break if fibs.length == @length
      fibs << fibs.last(2).reduce(:+)
    end
    fibs
  end
end
