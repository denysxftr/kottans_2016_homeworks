RSpec.describe SimpleRouter::Controller do
  let(:controller) { TestsController }

  context 'Request type' do
    it 'text' do
      expect(
        controller
          .action(:test)
          .call(Rack::MockRequest.env_for('/'))
      ).to eq([200, { 'Content-Type' => 'text/plain' }, ['Request method: GET']])
    end

    it 'json' do
      expect(
        controller
          .action(:show)
          .call(Rack::MockRequest.env_for('/post?name=hello&other_name=world'))
      ).to eq([200, { 'Content-Type' => 'application/json' }, ["{\"name\":\"hello\",\"other_name\":\"world\"}"]])
    end
  end
end
