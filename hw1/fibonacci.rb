# =====================================
# Generates the Fibonacci sequence
# =====================================
class Fibonacci
  include Enumerable

  def initialize(size)
    @size = size
  end

  def each
    rez = []
    rez << yield(0) if @size.zero?
    @size.times do |i|
      rez << (i < 2 ? 1 : rez[i-2] + rez[i-1])
      yield(rez[i])
    end
  end # each

  def to_s
    puts "fibo size = #{@size}\n" + "rez = #{map(&:to_s)}"
  end
end # Fibonacci
