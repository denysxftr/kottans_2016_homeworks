class Fibonacci
  include Enumerable

  attr_reader :sequence

  def initialize(length)
    if valid_length?(length)
      create_sequence(length)
    else
      raise ArgumentError, "Sequence length isn't valid."
    end
  end

  def each
    @sequence.each { |item| yield(item) }
  end

  private

  def valid_length?(length)
    length.is_a?(Integer) && length > 0
  end

  def create_sequence(length)
    @sequence = Array.new(length)
    previous = 1
    current = 1
    length.times do |i|
      if i < 2
        @sequence[i] = 1
      else
        @sequence[i] = previous + current
        previous = current
        current = sequence[i]
      end
    end
  end
end
