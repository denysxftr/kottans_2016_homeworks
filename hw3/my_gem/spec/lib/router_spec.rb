RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(_env) { [200, {}, ['get test']] }
      post '/test', ->(_env) { [200, {}, ['post test']] }
      get '/post/:name', ->(_env) { [200, {}, ['post page']] }
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when visiting not existing page' do
    let(:env) do
      {
        'REQUEST_PATH' => '/not_found_path',
        'REQUEST_METHOD' => 'GET'
      }
    end
    it '404 error must appear' do
      expect(subject.call(env)).to eq [404, {}, ['page not found']]
    end
  end

  context 'when visiting post with a number' do
    let(:env) { { 'REQUEST_PATH' => '/post/43', 'REQUEST_METHOD' => 'GET' } }
    it 'we should see /43 post' do
      expect(subject.call(env)).to eq [200, {}, ['post page']]
    end
  end

  context 'when visiting post with a text' do
    let(:env) do
      { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET' }
    end
    it 'we should see /about_ruby post' do
      expect(subject.call(env)).to eq [200, {}, ['post page']]
    end
  end

  context 'when writting path UPPERCASE' do
    let(:env) do
      { 'REQUEST_PATH' => '/TEST', 'REQUEST_METHOD' => 'GET' }
    end
    it 'it must still render page' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end
end
