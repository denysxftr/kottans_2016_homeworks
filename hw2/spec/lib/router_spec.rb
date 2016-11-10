RSpec.describe Router do
  subject do
    Router.new do
      get '/posts', ->(_) { [200, {}, ['get posts']] }
      get '/posts/:id', ->(_) { [200, {}, ['show post']] }
      post '/posts', ->(_) { [200, {}, ['create post']] }
      patch '/posts/:id', ->(_) { [200, {}, ['update post']] }
      put '/posts/:id', ->(_) { [200, {}, ['update post']] }
      delete '/posts/:id', ->(_) { [200, {}, ['delete post']] }
    end
  end

  context 'when request is GET' do
    it 'matches /posts request' do
      env = { 'REQUEST_PATH' => '/posts', 'REQUEST_METHOD' => 'GET' }
      expect(subject.call(env)).to eq [200, {}, ['get posts']]
    end

    it 'matches /posts/:id request' do
      env = { 'REQUEST_PATH' => '/posts/123_a-b', 'REQUEST_METHOD' => 'GET' }
      expect(subject.call(env)).to eq [200, {}, ['show post']]
    end

    it 'returns 404 if path not found' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' }
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is POST' do
    it 'matches /posts request' do
      env = { 'REQUEST_PATH' => '/posts', 'REQUEST_METHOD' => 'POST' }
      expect(subject.call(env)).to eq [200, {}, ['create post']]
    end

    it 'returns 404 if path not found' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' }
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is PATCH' do
    it 'matches /posts/:id request' do
      env = { 'REQUEST_PATH' => '/posts/123_a-b', 'REQUEST_METHOD' => 'PATCH' }
      expect(subject.call(env)).to eq [200, {}, ['update post']]
    end

    it 'returns 404 if path not found' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'PATCH' }
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is PUT' do
    it 'matches /posts/:id request' do
      env = { 'REQUEST_PATH' => '/posts/123_a-b', 'REQUEST_METHOD' => 'PUT' }
      expect(subject.call(env)).to eq [200, {}, ['update post']]
    end

    it 'returns 404 if path not found' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'PUT' }
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is DELETE' do
    it 'matches /posts/:id request' do
      env = { 'REQUEST_PATH' => '/posts/123_a-b', 'REQUEST_METHOD' => 'DELETE' }
      expect(subject.call(env)).to eq [200, {}, ['delete post']]
    end

    it 'returns 404 if path not found' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'DELETE' }
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end
end
