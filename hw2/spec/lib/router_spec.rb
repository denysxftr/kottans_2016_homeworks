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
      post '/post/:name', ->(env) { [200, {}, ['post create page']] }
      get '/test/:id/with/:smth', ->(env) { [200, {}, ['got get request with id and something']] }
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
  context 'when has params in path, ' do

    let(:env) { { 'REQUEST_PATH' => '/post/Smith', 'REQUEST_METHOD' => 'POST'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post create page']]
    end
  end
  context 'when has lots of params in path, ' do
    let(:env) { { 'REQUEST_PATH' => '/test/1/with/me', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['got get request with id and something']]
    end
  end

end
