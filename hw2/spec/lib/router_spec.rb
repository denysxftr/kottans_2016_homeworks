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

    context 'when page not found' do
      let(:env) { { 'REQUEST_PATH' => '/not_found', 'REQUEST_METHOD' => 'GET'} }

      it 'returns 404' do
        expect(subject.call(env)).to eq [404, {}, ['Not Found']]
      end
    end

    context 'when request has Pattern: /post/:name' do

      context ':name is String' do
        let(:env) { { 'REQUEST_PATH' => '/post/super_post', 'REQUEST_METHOD' => 'GET'} }

        it 'returns /post/super_post' do
          expect(subject.call(env)).to eq [200, {}, ['post show page']]
        end
      end

      context ':name is Numeric' do
        let(:env) { { 'REQUEST_PATH' => '/post/13', 'REQUEST_METHOD' => 'GET'} }

        it 'returns /post/super_post' do
          expect(subject.call(env)).to eq [200, {}, ['post show page']]
        end
      end
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
