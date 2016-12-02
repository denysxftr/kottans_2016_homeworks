require 'spec_helper'
RSpec.describe Hola::Controller do
  let(:controller) do
    Class.new(Hola::Controller) do
      def text_action
        response(:text, 'test')
      end

      def json_action
        response(:json, params)
      end

      def params_data
        response(:json, some_key: params['some_value'])
      end
    end
  end

  context 'request status' do
    it 'text type' do
      expect(controller.action(:text_action).call(Rack::MockRequest.env_for('/')))
      .to eq([200, {'Content-Type' => 'text/plain' }, ['test']])
    end

    it 'json type' do
      expect(controller.action(:json_action).call(Rack::MockRequest.env_for('/json')))
      .to eq([200, { 'Content-Type' => 'application/json' }, ["{}"]])
    end

    it 'params hash' do
      expect(controller.action(:params_data).call(Rack::MockRequest.env_for('/post?some_value=qwerty')))
      .to eq([200, { 'Content-Type' => 'application/json' }, ["{\":some_key\":\"qwerty\"}"]])
    end

  end
end
