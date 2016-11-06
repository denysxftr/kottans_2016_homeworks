class Fibonacci
	include Enumerable

	def initialize( n )
		@n = n
	end

	def each
		sequence = Array.new
		sequence << 0 if @n == 0
		if @n > 1 
			sequence << 1
			@n -= 1
		end

  	x, y = 0, 1

	  (1..@n).map do
	    z = (x + y)
	    x = y
	    y = z
	    sequence << y.to_s
	  end
	  sequence.map(&:to_s)
	end

	def map
		each
	end
end