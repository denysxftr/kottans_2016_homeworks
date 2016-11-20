RSpec.describe Controller do
  let(:controller) do
    Class.new(Controller) do
      def test_json
        response(:json, { "key" => "value" })
      end

      def test_text
        response(:text, 'text')
      end
    end
  end

  let(:root) { Rack::MockRequest.env_for('/') }
  let(:test_json) { controller.action(:test_json).call(root) }
  let(:test_text) { controller.action(:test_text).call(root) }

  it 'is a rack application' do
    expect(controller.action(:test_text)).to respond_to :call
    expect(test_text).to be_an Array
    expect(test_text.size).to eq 3
  end

  it 'json matches request' do
    expect(test_json).to eq [
      200,
      {'Content-Type' => 'application/json'},
      ['{"key":"value"}']
    ]
  end

  it 'text matches request' do
    expect(test_text).to eq [
      200,
      {'Content-Type' => 'text/plain'},
      ['text']
    ]
  end
end
