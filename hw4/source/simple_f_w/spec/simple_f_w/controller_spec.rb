require 'spec_helper'

describe Controller do

  let(:controller) do
    Class.new(described_class) do
      def test_action
        response(:text, 'test')
      end

      def text_action
        response(:text, 'test')
      end

      def json_action
        response(:json, params)
      end
    end
  end

  describe '#action' do
    it 'returns proc' do
      expect(controller.action(:test)).to be_is_a(Proc)
    end

    it 'generated proc calls action' do
      expect(controller.action(:test_action).call(Rack::MockRequest.env_for('/')))
        .to eq([200, { 'Content-Type' => 'text/plain' }, ['test']])
    end
  end

  describe 'request processing' do
    subject do
      controller
        .action(action)
        .call(Rack::MockRequest.env_for('/sometext').merge!(router_params))
    end

    let(:router_params) { {} }

    context 'when json response' do
      let(:action) { :json_action }
      it 'successfully responds' do
        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'application/json' },
            ['{}']
          ])
      end
    end

    context 'when text response' do
      let(:action) { :text_action }
      it 'successfully responds' do
        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'text/plain' },
            ["test"]
          ])
      end
    end
  end
end
