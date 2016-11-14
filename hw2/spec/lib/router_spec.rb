RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }

      get '/post/:post_id/comment/:comment_id', ->(env) { [200, {}, ["Post id: #{env['params']['post_id']}, comment id: #{env['params']['comment_id']}"]] }
      get '/post/:post_id', ->(env) { [200, {}, ["Post id: #{env['params']['post_id']}"]] }
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

  context 'when request is GET with param post_id' do
    let(:env) {{ 'REQUEST_PATH' => '/post/43', 'REQUEST_METHOD' => 'GET'}}

    it 'matches request' do 
        expect(subject.call(env)).to eq [200, {}, ['Post id: 43']]
    end
  end

  context 'when request is GET with params post_id and comment_id' do
    let(:env) {{ 'REQUEST_PATH' => '/post/43/comment/77', 'REQUEST_METHOD' => 'GET'}}

    it 'matches request' do 
        expect(subject.call(env)).to eq [200, {}, ['Post id: 43, comment id: 77']]
    end
  end

  context 'when page is not exist' do
    let(:env) {{ 'REQUEST_PATH' => '/winter', 'REQUEST_METHOD' => 'GET'}}

    it 'matches request' do 
        expect(subject.call(env)).to eq [404, {}, ['Page not found']]
    end
  end
end
