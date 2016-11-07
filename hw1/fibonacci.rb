class Fibonacci
  include Enumerable
  def initialize(times)
    @times,@a,@b,@c = times,1,1,1;
  end
  def each
    @times.times do
      yield @a;@a=@b;@b=@a+@c;@c=@a;
    end
  end
end
