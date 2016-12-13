RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }

      get '/users/5', ->(env) { [200, {}, ['get /users/:id']] }
      get '/users/5/comments/2/rating/4', ->(env) { [200, {}, ['get /users/:id/comments/:comment/rating/:rating']] }
      get '/users/articles/14', ->(env) { [200, {}, ['get /users/articles/:title']]}
      get '/', ->(env) { [404, {}, ['page not found']] }
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

  context 'router by pattern /users/:id' do
    let(:env) { { 'REQUEST_PATH' => "/users/5", 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get /users/:id']]
    end
  end

  context 'router by pattern /users/:id/comments/:comment/rating/:rating' do
    let(:env) { { 'REQUEST_PATH' => "/users/5/comments/2/rating/4", 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get /users/:id/comments/:comment/rating/:rating']]
    end
  end

  context 'router by pattern /users/articles/:title' do
    let(:env) { { 'REQUEST_PATH' => "/users/articles/14", 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get /users/articles/:title']]
    end
  end

  context 'when path has parameter' do
    let(:env) { { 'REQUEST_PATH' => "/", 'REQUEST_METHOD' => 'GET'} }

    it 'returns 404' do
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

end