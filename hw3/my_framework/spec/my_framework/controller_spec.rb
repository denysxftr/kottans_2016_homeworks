require './lib/my_framework/controller'
require 'Rack'
require 'oj' 
# no idea why i have to require all of this here but it doesn't work if don't
# throws bazzilion of warnings though

RSpec.describe Controller do
  let(:controller) do
    Class.new(Controller) do
      def show
        response(:text, 'text')
      end

      def test
        response(:json, { "some_key" => "some_value" } )
      end
    end
  end

  let(:mock_http) { Rack::MockRequest.env_for('/') }
  let(:show) { controller.action(:show).call(mock_http) }
  let(:test) { controller.action(:test).call(mock_http) }  

  context 'when request is to text route' do
    it 'responds with text' do
      expect(show).to eq [200, {'Content-Type' => 'text/plain'},['text']]
    end
  end

  context 'when request is to json route' do
    it 'responds with json' do
      expect(test).to eq [200, {'Content-Type' => 'application/json'},['{"some_key":"some_value"}']]
    end
  end

end