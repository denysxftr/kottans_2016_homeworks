require "spec_helper"

describe WebConfig::Config do
  describe '.load' do
    let(:file) { instance_double('File') }
    subject { described_class.load(file) }

    before do
      expect(file).to receive(:readlines).and_return(host)
    end

    context 'when file is valid' do
      let(:host) { '172.17.0.1' }

      it 'parses value' do
        expect(subject.host).to eq host
      end
    end

    context 'when file is not valid' do
      let(:host) { '' }

      it 'raises exception' do
        expect { subject }.to raise_error(RuntimeError)
      end
    end
  end

  describe '#host' do
    subject { config_instance.host }

    context 'when there is default value' do
      let(:config_instance) { described_class.new }

      it 'returns default value' do
        expect(subject).to eq 'localhost'
      end
    end

    context 'when there is not default value' do
      let(:config_instance) { described_class.new(host: host) }
      let(:host) { '172.17.0.1' }

      it 'returns specified value' do
        expect(subject).to eq host
      end
    end
  end

  # describe '#port' do
  #   context 'when there is default value' do
  #   end
  #
  #   context 'when there is not default value' do
  #   end
  # end
end
