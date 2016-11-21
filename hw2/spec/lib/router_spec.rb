RSpec.describe Router do
  subject do
    Router.new do
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

  context 'when path has parameter' do
    let(:env) { { 'REQUEST_PATH' => '/post/about-ruby', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post show page']]
    end
  end

  context 'when path is not defined in router' do
    let(:env) { { 'REQUEST_PATH' => '/asdkahbdfma', 'REQUEST_METHOD' => 'GET'} }

    it 'should respond with 404 page not found' do
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end
end
