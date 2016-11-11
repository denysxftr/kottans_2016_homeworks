RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }

      get  '/post/:name', ->(env) { [200, {}, ['get test with name about_ruby']] }
      post '/post/:name', ->(env) { [200, {}, ['post test with name 43']] }

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
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test with name about_ruby']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end

    let(:env) { { 'REQUEST_PATH' => '/post/43', 'REQUEST_METHOD' => 'POST' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test with name 43']]
    end
  end
end
