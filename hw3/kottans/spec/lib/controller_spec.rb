RSpec.describe Controller do
  let(:controller) do
    Class.new(described_class) do
      def test_action
        response(:text, 'test')
      end

      def text_action
        response(:text, params.inspect)
      end

      def json_action
        response(:json, params)
      end
    end
  end

  describe 'request processing' do
    subject do
      controller
        .action(action)
        .call(Rack::MockRequest.env_for('/?a=b').merge!(router_params))
    end

    let(:router_params) { {} }

    context 'when text response' do
      let(:action) { :text_action }

      it 'successfully responds' do
        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'text/plain' },
            ['{"a"=>"b"}']
          ])
      end
    end

    context 'when json response' do
      let(:action) { :json_action }

      it 'successfully responds' do
        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'application/json' },
            ['{"a":"b"}']
          ])
      end
    end
  end
end