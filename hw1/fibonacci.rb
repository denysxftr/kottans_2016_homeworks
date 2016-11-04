class Fibonacci
  include Enumerable

  def initialize(length)
    if valid_length?(length)
      @length = length
    else
      raise ArgumentError, "Sequence length isn't valid."
    end
  end

  def each
    previous = 1
    current = 1
    @length.times do |i|
      if i < 2
        yield 1
      else
        new_value = previous + current
        previous, current = current, new_value
        yield new_value
      end
    end
  end

  private

  def valid_length?(length)
    length.is_a?(Integer) && length > 0
  end
end
