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
    fibo.each { |f| yield(f) }
  end

  private

  def fibo
    base = [1, 1]
    return [1] if quantity == 1
    return base if quantity == 2
    (quantity - 2).times do |q|
      base.push(base[q] + base[q + 1])
    end
    base
  end
end
