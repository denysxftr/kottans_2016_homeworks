require "spec_helper"
require 'rack'
require 'oj'

RSpec.describe Asdetmin::Controller do
  let(:controller) do

    Class.new(Asdetmin::Controller) do
      def text_action
        response(:text, 'hello world')
      end

      def json_action
        response(:json, params)
      end

      def data_with_params
        response(:json, some_key: params['some_value'])
      end
    end
  end

  context 'shows request status, header and response' do
    it 'for action wit text type' do
      expect(controller.action(:text_action).call(Rack::MockRequest.env_for('/test_in_text')))
          .to eq([200, { 'Content-Type' => 'text/plain' }, ['hello world']])
    end

    it 'for action with json type' do
      expect(controller.action(:json_action).call(Rack::MockRequest.env_for('/test_in_json')))
          .to eq([200, { 'Content-Type' => 'application/json' }, ["{}"]])
    end
  end

  it 'shows readed param from address line to params hash' do
    expect(controller.action(:data_with_params).call(Rack::MockRequest.env_for('/test?some_value=blabla')))
        .to eq([200, { 'Content-Type' => 'application/json' }, ["{\":some_key\":\"blabla\"}"]])
  end
end