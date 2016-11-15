class Fibonacci

  include Enumerable

  def initialize(number)
    @number = number
    @fibonacci = [0,1]
  end

  def each(&block)
  	fst = @fibonacci[0]
  	snd = @fibonacci[1]
  	i = 0
  	loop do
      @fibonacci[i] = fst + snd
      fst = snd
      snd = @fibonacci[i]

	  i+=1 
      if(i > @number)
        break
      end

      yield fst
    end
  end
end
