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
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

    it 'returns 404 error for missing path' do
      expect(subject.call({ 'REQUEST_PATH' => '/not_found_path', 'REQUEST_METHOD' => 'GET'})).to eq [404, {}, ['not found']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'when request is nested "post"' do
      it 'matches request if nested' do
        env['REQUEST_PATH'] = '/post/some_string'
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end

      it 'matches request if nested and ends on /' do
        env['REQUEST_PATH'] = '/post/some_string/'
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end

      it 'not matches request if deep nested post url' do
        env['REQUEST_PATH'] = '/post/some_string/string'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end

      it 'not matches request if url is not nested but "post"' do
        env['REQUEST_PATH'] = '/post/'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'returns 404 error for missing path' do
      expect(subject.call({ 'REQUEST_PATH' => '/not_found_path', 'REQUEST_METHOD' => 'POST'})).to eq [404, {}, ['not found']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
