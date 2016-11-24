RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
      get '/post/:name/edit', ->(env) { [200, {}, ['edit post show page']] }
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    it 'matches patterned request' do
      ['43', 'about_ruby'].each do |path|
        env = { 'REQUEST_PATH' => "/post/#{path}", 'REQUEST_METHOD' => 'GET'}
        expect(subject.call(env)).to eq [200, {}, ['post show page']]

        env = { 'REQUEST_PATH' => "/post/#{path}/edit", 'REQUEST_METHOD' => 'GET'}
        expect(subject.call(env)).to eq [200, {}, ['edit post show page']]
      end
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when request does not match the routes' do
    it 'returns 404 when request path does not exist in the routes' do
      ['GET', 'POST'].each do |method|
        ['/nothing_here', '/post/something/oops'].each do |path|
          env = { 'REQUEST_PATH' => path, 'REQUEST_METHOD' => method }
          expect(subject.call(env)).to eq [404, {}, ['not found']]
        end
      end
    end
  end
end
