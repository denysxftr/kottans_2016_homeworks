class Fibonacci
  include Enumerable

  def initialize(length)
    @length = length
  end

  def each
    prev_value = 1
    value = 1
    @length.times do

      yield prev_value

      prev_value, value = value, prev_value + value
    end
  end
end
