require 'spec_helper'

RSpec.describe Controller do
  let(:controller) do
    Class.new(Controller) do
      def text_action
        response(:text, 'text response')
      end

      def json_action
        response(:json, params)
      end

      def json_params_action
        response(:json, key: params['value'])
      end
    end
  end

  context 'requests with controller by type' do
    it 'text type' do
      expect(controller.action(:text_action).call(Rack::MockRequest.env_for('/')))
          .to eq([200, {'Content-Type' => 'text/plain' }, ['text response']])
    end

    it 'json type without params' do
      expect(controller.action(:json_action).call(Rack::MockRequest.env_for('/json')))
          .to eq([200, { 'Content-Type' => 'application/json' }, ['{}']])
    end

    it 'json type with params' do
      expect(controller.action(:json_params_action).call(Rack::MockRequest.env_for('/json?value=name')))
        .to eq([200, { 'Content-Type' => 'application/json' }, ['{":key":"name"}']])
    end
  end
end