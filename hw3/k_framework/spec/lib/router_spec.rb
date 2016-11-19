RSpec.describe KFramework::Router do
  subject do
    KFramework::Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }

      class TestController
        def self.action(action_name)
          ->(env) { [200, {}, ['ctrl test']] }
        end
      end

      get '/ctrl', 'test#action'
    end
  end

  shared_examples 'handles requests to unknown routes' do
    it 'returns 404 for unknown routes' do
      expect(subject.call(unknown_env)).to eq [404, {}, ['not found']]
    end
  end

  context 'when request is GET' do
    include_examples 'handles requests to unknown routes'

    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }
    let(:env_with_param) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET'} }
    let(:unknown_env) { {'REQUEST_PATH' => '/wut', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    it 'matches route with named parameter' do
      expect(subject.call(env_with_param)).to eq [200, {}, ['post show page']]
    end

    it 'adds parsed paramaters to the env' do
      subject.call(env_with_param)
      expect(env_with_param['router.params']).to eq({ 'name' => 'about_ruby' })
    end
  end

  context 'when request is POST' do
    include_examples 'handles requests to unknown routes'

    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }
    let(:unknown_env) { {'REQUEST_PATH' => '/wut', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  it 'matches controller#action string' do
    env = { 'REQUEST_PATH' => '/ctrl', 'REQUEST_METHOD' => 'GET'}
    expect(subject.call(env)).to eq [200, {}, ['ctrl test']]
  end
end
