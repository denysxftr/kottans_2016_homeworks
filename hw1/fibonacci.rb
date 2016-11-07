class Fibonacci
  attr_reader :result_array
  include Enumerable

  def each()
    (1..result_array.size).each_with_index{ |_, i| yield(result_array[i]) }
    self
  end

  private

  def initialize(length)
    raise TypeError, "Expected argument to be Integer" unless [Fixnum, Bignum].include? length.class
    raise ArgumentError, "Expected argument >= 1. Got #{length}" if length < 1

    a = b = 1
    @result_array = []
    (1..length).each{ @result_array << a; a, b = b, a; b += a;  }
    @result_array
  end
end