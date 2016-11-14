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
    let(:env_with_pattern) { { 'REQUEST_PATH' => '/post/' + (0...10).map { ('a'..'z').to_a[rand(26)] }.join, 'REQUEST_METHOD' => 'GET'}}
    let(:unknown_route) { { 'REQUEST_PATH' => '/' + (0...10).map { ('a'..'z').to_a[rand(26)] }.join, 'REQUEST_METHOD' => 'GET'}}


    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    it 'matches request with pattern' do
      expect(subject.call(env_with_pattern)).to eq [200, {}, ['post show page']]
    end

    it 'matches request to uknown route' do
      expect(subject.call(unknown_route)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
