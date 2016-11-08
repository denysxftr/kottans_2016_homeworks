RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }

      ##
      # TODO: router should match path by pattern like
      # Pattern: /posts/:name
      # Paths:
      # /post/about_ruby
      # /post/43
      # Cover this with tests.
      #
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
    end
  end

  context 'when request is GET' do
    context 'to defined routes' do
      let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['get test']]
      end
    end

    context 'to undefined routes' do
      let(:unknown_env) { {'REQUEST_PATH' => '/wut', 'REQUEST_METHOD' => 'GET'} }

      it 'returns 404 for unknown routes' do
        expect(subject.call(unknown_env)).to eq [404, {}, ['not found']]
      end
    end

  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
