class Fibonacci
  include Enumerable

  def initialize(length)
    unless valid_length?(length)
      raise ArgumentError, "Sequence length isn't valid."
    end
    @length = length
    @array = Array.new(@length)
  end

  def each
    previous = 0
    current = 1
    @length.times do |i|
      @array[i] = current
      yield current
      previous, current = current, previous + current
    end
    @array
  end

  private

  def valid_length?(length)
    length.is_a?(Integer) && length > 0
  end
end
