RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/wrong_path',  ->(env) {[404, {}, ['Not found!']]}
      get '/posts/:name', ->(env) { [200, {}, ['post show page']] }
      get '/posts/:name/page/:page', ->(env) { [200, {}, ['post show page with pages']] }
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

  context 'GET request for wrong path' do
    let(:env) { { 'REQUEST_PATH' => '/wrong_path', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [404, {}, ['Not found!']]
    end
  end

  context 'Get request for post/:name' do
    ['43', 'about_ruby'].each do |name|
      let(:env) { { 'REQUEST_PATH' => "/posts/#{name}", 'REQUEST_METHOD' => 'GET'} }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end
    end
  end

  context 'Get request for post/:name/page/:page' do
      let(:env) { { 'REQUEST_PATH' => "/posts/12/page/1", 'REQUEST_METHOD' => 'GET'} }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, {}, ['post show page with pages']]
      end
  end
end
