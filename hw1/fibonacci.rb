class Fibonacci
include Enumerable
def initialize(length)
   @length = length 
end
def each
  sequence = []
  while sequence.length < @length do 
  	if sequence.length == 0
  		sequence.push(1)
  		yield 1
  	elsif sequence.length == 1 
  		sequence.push (1)
  		yield 1
  	else 
  		sequence.push (sequence[sequence.length-1]+sequence[sequence.length-2])
  		yield sequence[sequence.length-1]
  	end
  end
end
end
