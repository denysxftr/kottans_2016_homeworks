RSpec.describe KottansFramework::Router do
  subject do
    KottansFramework::Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/test/:message', ->(env) { [200, {}, ['test with params']] }
      get '/post/:name', ->(env) do
        [200,
         {},
         [env['router.params']['name'], 'post show page']]
      end

      get '/post/:name/comment/:id', ->(env) do
        [200,
         {},
         [env['router.params']['name'], env['router.params']['id'], 'post comment show page']]
      end
    end
  end

  context 'when request is GET' do
    it 'matches request' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' }
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is POST' do
    it 'matches request' do
      env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' }
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when request with params' do
    it 'matches request' do
      env_with_params = {
        'REQUEST_PATH' => '/test/123-abc',
        'REQUEST_METHOD' => 'GET'
      }
      expect(subject.call(env_with_params)).to eq [200, {}, ['test with params']]
    end

    it 'adds params to env' do
      env_with_params = {
        'REQUEST_PATH' => '/post/about_ruby',
        'REQUEST_METHOD' => 'GET'
      }
      expect(subject.call(env_with_params)).to eq [200, {}, ['about_ruby', 'post show page']]
    end

    it 'adds few params to env' do
      env_with_params = {
        'REQUEST_PATH' => '/post/13/comment/48',
        'REQUEST_METHOD' => 'GET'
      }
      expect(subject.call(env_with_params)).to eq [200,
                                                   {},
                                                   ['13', '48', 'post comment show page']]
    end
  end

  context 'when route not found' do
    it 'returns 404 status when no page found' do
      wrong_env = { 'REQUEST_PATH' => 'wrong_pass', 'REQUEST_METHOD' => 'GET' }
      expect(subject.call(wrong_env)).to eq [404, {}, ['Page not found']]
    end
  end
end
