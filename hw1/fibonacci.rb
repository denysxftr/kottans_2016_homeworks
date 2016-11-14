
class Fibonacci
 include Enumerable

def fibonacci(n)
    a = 1
    b = 1
    n.times do
	temp = a
	a = b
	b = temp + b
    end

    return a
end


def each(&block)
    @num.times do |n|
    block.call(fibonacci(n))
end


  end

def initialize(num)
@num = num

	end
end

class Fibonacci
 include Enumerable

def fibonacci(n)
    a = 1
    b = 1
    n.times do
        temp = a
        a = b
        b = temp + b
    end

    return a
end


def each(&block)
    @num.times do |n|
    block.call(fibonacci(n))
end


  end

def initialize(num)
@num = num

        end
end
