RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      get '/post/:name', ->(env) { [200, {}, ["get test with name #{env['params']['name']}"]] }

      post '/test', ->(env) { [200, {}, ['post test']] }
    end
  end

  context 'when request is GET' do
    context 'when request is "/test"' do
      let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['get test']]
      end
    end

    context 'when request is "/posts/:name"' do
      let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET' } }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['get test with name about_ruby']]
      end
    end
  end

  context 'when request is POST' do
    context 'when request is "/test"' do
      let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['post test']]
      end
    end
  end
end
