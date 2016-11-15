RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      post '/users/:id/comments/:comment/rating/:rating', ->(env) { [200, {}, ['post with users comment rating']] }
      post '/users/articles/:title', ->(env) { [200, {}, ['post with user articles title']] }
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

  context 'when request is /users/:id/comments/:comment/rating/:rating' do
    let(:env) { { 'REQUEST_PATH' => '/users/:id/comments/:comment/rating/:rating', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post with users comment rating']]
    end
  end

  context 'when request is /users/articles/:title' do
    let(:env) { { 'REQUEST_PATH' => '/users/articles/:title', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post with user articles title']]
    end
  end
  
  context 'when request is /articles/?author=/:author&subject=:subject' do
    let(:env) { { 'REQUEST_PATH' => '/articles?author=:author&subject=:subject', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when request is /users/strange/:title' do
    let(:env) { { 'REQUEST_PATH' => '/users/strange/:title', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end
end




