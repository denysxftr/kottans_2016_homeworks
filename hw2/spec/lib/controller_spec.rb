RSpec.describe Controller do
  let(:controller) do

    Class.new(Controller) do
      def text_action
        response(:text, 'test text')
      end

      def json_action
        response(:json, params)
      end

      def data_params
        response(:json, some_key: params['some_info'])
      end
    end
  end

  context 'shows request status' do
    it 'for action with text type' do
      expect(controller.action(:text_action).call(Rack::MockRequest.env_for('/test_in_text')))
          .to eq([200, { 'Content-Type' => 'text/plain' }, ['test text']])
    end

    it 'for action with json type' do
      expect(controller.action(:json_action).call(Rack::MockRequest.env_for('/test_in_json')))
          .to eq([200, { 'Content-Type' => 'application/json' }, ["{}"]])
    end
  end

  it 'shows readed param from address line to params hash' do
    expect(controller.action(:data_params).call(Rack::MockRequest.env_for('/test?some_info=key')))
        .to eq([200, { 'Content-Type' => 'application/json' }, ["{\":some_key\":\"key\"}"]])
  end
end
