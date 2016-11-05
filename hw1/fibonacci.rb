class Fibonacci
  include Enumerable

  def initialize(seq_num)
    @seq_num = seq_num
  end

  def each
    n = 0
    fib_seq = [1]
    until n == @seq_num
      yield (fib_seq[n])
      fib_seq.size < 2 ? fib_seq << fib_seq[0] : fib_seq << fib_seq[n] + fib_seq[n-1]
      n += 1
    end
  end

end
