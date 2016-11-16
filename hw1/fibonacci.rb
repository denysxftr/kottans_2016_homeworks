class Fibonacci
  include Enumerable

  def initialize(limit)
    @fibos = build(limit)
  end

  def each
    return enum_for(:each) unless block_given?
    @fibos.each do |fib|
      yield fib
    end
  end

  private

  def build(limit)
    i = 0
    arr ||= []
    fib1, fib2 = 0, 1
    loop do
      break if i == limit
      arr << fib2
      i += 1
      fib1, fib2 = fib2, fib2 + fib1
    end
    arr
  end
  # (0...limit).reduce([]) do |arr, i|
  #   arr << (arr.first.nil? || arr[1].nil? ? 1 : arr[i-2] + arr[i-1])
  #   arr
  # end
end
