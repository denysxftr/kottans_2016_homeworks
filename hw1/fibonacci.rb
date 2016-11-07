class Fibonacci
	include Enumerable

	def initialize(n)
		@n = n
	end

	def each()
    		a, b = 1, 1
    		@n.times do
      		yield a
      		a, b = b, a+b
		end
	end
end
