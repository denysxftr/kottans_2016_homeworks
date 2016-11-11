class Fibonacci
  include Enumerable

  def initialize(fibonacci_length)
    @fibonacci_length = fibonacci_length
  end

  ##
  # The Way It Need to be Done (Retur Array with all numbers that it passed)
  def each()
    fibonacci_sequnce = Array.new
    first, second = 1, 0

    @fibonacci_length.times do
      fibonacci_sequnce << first
      first, second = first + second, first
    end

    fibonacci_sequnce.each do | element |
      yield(element)
    end
  end

  ##
  # The Way I Like to do It
=begin
  def each()
    first, second = 1, 0
    (1..@fibonacci_length).each do
      yield(first)

      first, second = first + second, first
    end
  end
=end
  ##
  # Without Recursion (only with variables)
=begin
  def each()
    first, second = 1, 0
    @fibonacci_length.times do
      yield(first)

      first, second = first + second, first
    end
  end
=end

  ##
  # Without Recursion (with array)
=begin
  def each()
    counter = 0
    fibonacci_sequence = [1]
    until counter == @fibonacci_length
      yield(fibonacci_sequence[counter])

      if fibonacci_sequence.length < 2
        fibonacci_sequence << fibonacci_sequence[0]
      else
        fibonacci_sequence << (fibonacci_sequence[counter] + fibonacci_sequence[counter - 1])
      end

      counter += 1
    end
  end
=end
end
