class Fibonacci
  include Enumerable

  def initialize(size)
    @size = size
  end

  def each
    previous_val = current_val = 1

    @size.times do
      yield previous_val

      temp = previous_val
      previous_val = current_val
      current_val = temp + current_val
    end
  end
end
