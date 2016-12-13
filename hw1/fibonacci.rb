class Fibonacci
	include Enumerable

	def initialize( n )
		@n = n
	end

	def each
  	x, y = 0, 1

	  @n.times do
	    z = (x + y)
	    x = y
	    y = z
	  	yield x
	  end
	end
end