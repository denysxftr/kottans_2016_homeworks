class Fibonacci
	include Enumerable

	def initialize(n)
		generate_first_n_fibonacci_numbers(n)
	end

	FIRST_NUMBER = 1
	SECOND_NUMBER = 1

	def each
		@sequence.each do |number|
			yield number
		end
	end

	private

	def generate_first_n_fibonacci_numbers(n)
		if n < 1
			raise 'n has to be 1 or more'
		end
		@sequence = []
		second_to_last_number = FIRST_NUMBER
		last_number = SECOND_NUMBER
		1.upto(n) do |x|
			if x == 1
				@sequence << FIRST_NUMBER
			elsif x == 2
				@sequence << SECOND_NUMBER
			else
				@sequence << second_to_last_number + last_number
				last_number = last_number + second_to_last_number
				second_to_last_number = last_number - second_to_last_number
			end
		end
	end
end