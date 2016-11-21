require "spec_helper"

describe SimpleFramework::Controller do

  let(:controller) do
    Class.new(described_class) do
      def test_action
        response(:text, 'test')
      end

      def text_action
        response(:text, 'text')
      end

      def json_action
        response(:json, {"one" => 1})
      end

    end
  end

  let(:env) { Rack::MockRequest.env_for('/') }
  let(:test_text) { controller.action(:text_action).call(env) }
  let(:test_json) { controller.action(:json_action).call(env) }

  context '#call' do

    it 'returns proc' do
      expect(controller.action(:test)).to be_is_a(Proc)
    end

    it 'returns text' do
      expect(test_text).to eq [200, {'Content-Type' => 'text/plain'}, ['text']]
    end

    it 'returns json' do
      expect(test_json).to eq [200, {'Content-Type' => 'application/json'}, ['{"one":1}']]
    end
  end

end
