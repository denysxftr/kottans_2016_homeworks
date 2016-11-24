class Fibonacci
	include Enumerable

	def initialize(length)
		raise TypeError, 'argument is not an integer' unless length.is_a? Integer
		raise ArgumentError, 'argument is negative' if length < 0
		@length = length
	end

	def each
		n0, n1 = 1, 0
		for i in 0...@length
			x = n1 + n0
			yield x
			n0, n1 = n1, x
		end
	end
end
