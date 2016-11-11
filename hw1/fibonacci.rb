# Rubocop wants some additional inforamtion about this class, if I understand
# him correctly. But still I will provide some additional information
# about what this class do.
# Kottans HomeWork #1
class Fibonacci
  include Enumerable

  def initialize(fibonacci_length)
    @fibonacci_length = fibonacci_length
  end

  ##
  # The Way It Need to be Done (Retur Array with all numbers that it passed)
  def each
    fibonacci_sequnce = []
    first = 1
    second = 0
    count(@fibonacci_length, fibonacci_sequnce, first, second)
    fibonacci_sequnce.each do |element|
      yield(element)
    end
  end

  ##
  # Depending Method for 'each' on Top (rubocop)
  def count(how_many, array, f_element, s_element)
    how_many.times do
      array << f_element
      tmp = f_element
      f_element += s_element
      s_element = tmp
    end
  end

  ##
  # The Way I Like to do It
  # def each
  #   first, second = 1, 0
  #   (1..@fibonacci_length).each do
  #     yield(first)
  #
  #     first, second = first + second, first
  #   end
  # end

  ##
  # Without Recursion (only with variables)
  # def each()
  #   first, second = 1, 0
  #   @fibonacci_length.times do
  #     yield(first)
  #
  #     first, second = first + second, first
  #   end
  # end

  ##
  # Without Recursion (with array)
  # def each
  #   counter = 0
  #   fibonacci_sequence = [1]
  #   until counter == @fibonacci_length
  #     yield(fibonacci_sequence[counter])
  #
  #     if fibonacci_sequence.length < 2
  #       fibonacci_sequence << fibonacci_sequence[0]
  #     else
  #       first = fibonacci_sequence[counter]
  #       second = fibonacci_sequence[counter - 1]
  #       fibonacci_value = first + second
  #       fibonacci_sequence << fibonacci_value
  #     end
  #
  #     counter += 1
  #   end
  # end
end
