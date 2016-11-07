# Fibonacci sequence implementation through each method                                    # Alex Purhalo
class Fibonacci
  include Enumerable                # includes classes collection that allow to operate under each method
  # purpose - implement each method behavior

  def initialize(index)                                                              # passed index param
    @index = index                                                        # passes this param to instance
  end

  def each
    index = 0                                                              # initial number for iteration

    fir_num, sec_num = 0, 1                              # first and second number of sequence definition
    prev_val, bef_prev_v = sec_num, fir_num     # initial values for indexes before current index  # 0, 1

    cur_val = 1                                           # initial value of sequence for first iteration

    loop do
      index += 1                            # increments iteration number that equal passed - index param

      yield cur_val  # returning of sequence's values according to iteration number  # index: 10, # => 55

      # settings for next iteration
      cur_val = prev_val + bef_prev_v # changing of current value                   # ex: cur_val = 0 + 1
      prev_val, bef_prev_v = cur_val, prev_val     # resetting of values before value under current index

      index == @index && break      # breaks looping when iteration number is equal to passed index param
    end
  end
end

puts Fibonacci.new(10).map(&:to_s)             # shows how looks each method applying for Fibonacci class