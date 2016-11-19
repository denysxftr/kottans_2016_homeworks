RSpec.describe KFramework::Controller do
  let(:controller) do
    Class.new(KFramework::Controller) do
      def text_response
        response(:text, 'text')
      end

      def json_response
        response(:json, {"key" => "value"})
      end
    end
  end

  let(:root_env) { Rack::MockRequest.env_for('/') }
  let(:text_response) { controller.action(:text_response).call(root_env) }
  let(:json_response) { controller.action(:json_response).call(root_env) }

  it 'is a rack application' do
    expect(controller.action(:text_response)).to respond_to :call
    expect(text_response).to be_an Array
    expect(text_response.size).to eq 3
  end

  it 'responds with text' do
    expect(text_response).to eq [200, {'Content-Type' => 'text/plain'}, ['text']]
  end

  it 'responds with json' do
    expect(json_response).to eq [200, {'Content-Type' => 'application/json'}, ['{"key":"value"}']]
  end
end
