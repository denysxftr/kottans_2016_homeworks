# Provides iteration over fibonacci sequence within a given size of elements
class Fibonacci
  include Enumerable

  private

  attr_reader :quantity

  public

  def initialize(quantity = 1)
    @quantity = quantity.to_i
    raise 'Pass at least one number to iterate over!' if @quantity < 1
  end

  def each
    previous = 1
    two_steps_before = 1
    quantity.times do |index|
      current = index < 2 ? 1 : (previous + two_steps_before)
      two_steps_before = previous
      previous = current
      yield(current)
    end
  end
end
