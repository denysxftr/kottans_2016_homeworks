class Fibonacci
   include Enumerable
 
   def initialize(length)
     @length = length
   end
 
   def each(&block)
     @result = []
     for i in 1..@length
       if i < 3
         @result[i] = 1
       else
         @result[i] = @result[i - 1] + @result[i - 2]
       end
       yield @result[i]
     end
   end
 end