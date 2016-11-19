require 'rspec'

class Compiler
  class << self
    def eval(command, argument=nil)
      return nil if !argument && !respond_to?(command)
      respond_to?(argument.to_s) ? send(command, send(argument)) : send(command, argument)
    end

    def method_missing(name, argument)
      instance_variable_name = "@#{name.to_s}"

      instance_variable_set(instance_variable_name, argument)

      getter = proc { |*args| instance_variable_get(instance_variable_name) }

      singleton_class.send(:define_method, name, getter)
      # singleton_class.send :attr_reader, name
    end
  end
end

RSpec.configure do |config|
  config.color = true
end

RSpec.describe Compiler do
  let!(:subject) { Class.new(Compiler) }

  it 'stores variable' do
    subject.eval(:x, 5)
    expect(subject.instance_variable_get(:@x)).to eq 5
  end

  it 'retrieves assigned variable' do
    allow(subject).to receive(:x).and_return(5)
    expect(subject.eval(:x)).to eq 5
  end

  it 'does not retreive nonexistent variables' do
    expect(subject.eval(:x)).to be_nil
  end

  it 'executes commands with instance variables as arguments' do
    allow(subject).to receive(:x).and_return(5)
    expect(STDOUT).to receive(:puts).with(5)
    subject.eval(:puts, :x)
  end
end
