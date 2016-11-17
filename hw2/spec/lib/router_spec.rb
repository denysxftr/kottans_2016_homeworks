RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
      get '/blog/:page_id/posts/:post_id', (lambda do |env|
        [200, {}, ["get blog page: #{env[request_symbols][page_id]} post: #{env[request_symbols][post_id]}"]]
      end)
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    context 'when request is GET to non existen page' do
      let(:env) { { 'REQUEST_PATH' => '/not_exist', 'REQUEST_METHOD' => 'GET' } }

      it 'returns 404 for non existen pages' do
        expect(subject.call(env)).to eq [404, {}, ['Page not found']]
      end
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'when request is GET with params' do
      let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET' } }

      it 'matches request with params' do
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end
    end

    # it 'matches request with params and substitutes them' do
    #   env['REQUEST_PATH'] = '/blog/vasya/posts/about_ruby'
    #   expect(subject.call(env)).to eq [200, {}, ['get blog page: vasya post: about_ruby']]
    # end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'returns 404 for non existen pages' do
      expect(subject.call('REQUEST_PATH' => '/not_exist', 'REQUEST_METHOD' => 'POST')).to eq [404, {}, ['Page not found']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
