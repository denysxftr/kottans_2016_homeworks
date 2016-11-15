RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/some_path', ->(env) { [404, {}, ['not found']] }
      get '/post/:name', -> (env) {[200, {}, ['show post page']]}
      get '/some/:id/other/:id', -> (env) {[200, {}, ['some other path']]}
    end
  end


  context 'when request is GET' do
    let(:env) { { 'PATH_INFO' => '/test', 'REQUEST_METHOD' => 'GET'} }
    let(:env_params) { { 'PATH_INFO' => '/post/123', 'REQUEST_METHOD' => 'GET'} }
    let(:env_more_params) { { 'PATH_INFO' => '/some/21/other/12', 'REQUEST_METHOD' => 'GET'} }
    let(:unknown_env) { { 'PATH_INFO' => '/some_path', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    it 'matches request with named params' do
      expect(subject.call(env_params)).to eq [200, {}, ['show post page']]
    end

    it 'matches request with multiple named params' do
      expect(subject.call(env_more_params)).to eq [200, {}, ['some other path']]
    end

    it 'returns 404 when path is unknown' do
      expect(subject.call(unknown_env)).to eq [404, {}, ['not found']]
    end
  end


  context 'when request is POST' do
    let(:env) { { 'PATH_INFO' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
