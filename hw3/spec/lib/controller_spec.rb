require 'spec_helper'

RSpec.describe Hw3::Controller do
  let(:env) { Rack::MockRequest.env_for('/some_route') }
  let(:text_call) { controller.action(:text).call(env) }
  let(:json_call) { controller.action(:json).call(env) }
  let(:controller) do
    Class.new(Hw3::Controller) do
      def text
        response(:text, 'text')
      end

      def json
        response(:json, 'key' => 'value')
      end
    end
  end

  context '.action' do
    it 'returns proc' do
      expect(controller.action('')).to be_an_instance_of Proc
    end
  end

  context '#call' do
    it 'returns plain text' do
      expect(text_call).to eq [200, { 'Content-Type' => 'text/plain' }, ['text']]
    end

    it 'returns json formatted value' do
      expect(json_call).to eq [200, { 'Content-Type' => 'application/json' }, ['{"key":"value"}']]
    end

    it 'fetches router.params for url params' do
      env['router.params'] = { 'hello' => 'world'}

      controller.class_eval do
        def some_test
          response(:json, params)
        end
      end
      expect(controller.action(:some_test).call(env)).to eq [200, { 'Content-Type' => 'application/json' }, ['{"hello":"world"}']]
    end
  end
end
