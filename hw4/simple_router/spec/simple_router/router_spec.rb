RSpec.describe SimpleRouter::Router do
  subject do
    SimpleRouter::Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
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

  context 'when request has parameter' do
    let(:env) { { 'REQUEST_PATH' => '/post/hello_world', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post show page']]
    end
  end

  context 'when request in not found' do
    let(:env) { { 'REQUEST_PATH' => '/hehe/wewew', 'REQUEST_METHOD' => 'GET'} }

    it 'return 404' do
      expect(subject.call(env)).to eq [404, {}, ['not found']]
    end
  end
end
