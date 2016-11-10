class Fibonacci
  attr_reader :result_array
  include Enumerable

  def each
    result_array.each{ |item| yield item }
    self
  end

  private

  def initialize(length)
    raise TypeError, "Expected argument to be Integer" unless [Fixnum, Bignum].include? length.class
    raise ArgumentError, "Expected argument >= 1. Got #{length}" if length < 1

    previous_item = next_item = 1
    @result_array = (1..length).inject([]) do |result|
      result << previous_item
      previous_item, next_item = next_item, previous_item
      next_item += previous_item
      result
    end
  end
end
