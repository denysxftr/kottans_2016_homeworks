class Fibonacci
	include Enumerable
	
	def initialize (n)
		@n = n
	end

	def each
	    a, b = 0, 1
	    @n.times do
			temp = a
			a = b
			b = temp + b
			yield a
	    end
	end

end