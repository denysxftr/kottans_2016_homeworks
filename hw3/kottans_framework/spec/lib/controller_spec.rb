RSpec.describe KottansFramework::Controller do
  subject do
    Class.new(described_class) do
      def test_action
        response(:text, 'some text')
      end

      def text_action
        response(:text, 'text')
      end

      def json_action
        response(:json, {'key' => 'value'})
      end
    end
  end

  context '#action' do
    let(:env) { Rack::MockRequest.env_for('/') }

    it 'returns proc' do
      expect(subject.action(:test_action)).to be_is_a(Proc)
    end

    it 'calls action' do
      expect(
        subject.action(:test_action).call(env)
      ).to eq([200, { 'Content-Type' => 'text/plain' }, ['some text']])
    end

    context 'html response' do
      it 'response with html content' do
        expect(
          subject.action(:text_action).call(env)
        ).to eq([200, { 'Content-Type' => 'text/plain' }, ['text']])
      end
    end

    context 'json response' do
      it 'response with json content' do
        expect(
          subject.action(:json_action).call(env)
        ).to eq([200, { 'Content-Type' => 'application/json' }, ['{"key":"value"}']])
      end
    end
  end
end
