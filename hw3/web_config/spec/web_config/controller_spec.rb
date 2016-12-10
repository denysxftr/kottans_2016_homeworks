require 'spec_helper'
RSpec.describe WebConfig::Controller do
  let(:controller) do
    Class.new(WebConfig::Controller) do
      def show_text
        response(:text, 'text')
      end

      def show_json
        response(:json, {"key" => "value"})
      end
    end
  end
  let(:show_text) { controller.action(:show_text).call(Rack::MockRequest.env_for('/') ) }
  let(:show_json) { controller.action(:show_json).call(Rack::MockRequest.env_for('/') ) }

  it 'get response with Content-Typy text' do
    expect(show_text).to eq [200, {'Content-Type' => 'text/plain'}, ['text']]
  end

  it 'get response with Content-Type json' do
    expect(show_json).to eq [200, {'Content-Type' => 'application/json'}, ['{"key":"value"}']]
  end
end
