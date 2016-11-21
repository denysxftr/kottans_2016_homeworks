class Fibonacci

	include Enumerable

	def initialize(sequence_length)
		@sequence_length = sequence_length	
	end

	def each
		f_minus_two = 0
		f_minus_one = 1
		current_position = 1
		yield 1
		until current_position == @sequence_length 
			f_minus_one = f_minus_one + f_minus_two
			f_minus_two = f_minus_one - f_minus_two
			yield f_minus_one
			current_position += 1
		end

	end

end
