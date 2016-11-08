RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(_env) { [200, {}, ['get test']] }
      post '/test', ->(_env) { [200, {}, ['post test']] }

      ##
      # TODO: router should match path by pattern like
      # Pattern: /posts/:name
      # Paths:
      # /post/about_ruby
      # /post/43
      # Cover this with tests.
      #
      get '/post/:name', ->(_env) { [200, {}, ['post show page']] }
    end
  end

  context 'under GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'under POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'under unspecified route' do
    let(:envs) do
      [
        { 'REQUEST_PATH' => '/missing', 'REQUEST_METHOD' => 'GET' },
        { 'REQUEST_PATH' => '/missing', 'REQUEST_METHOD' => 'POST' }
      ]
    end

    it 'renders 404', :focus do
      envs.each do |env|
        expect(subject.call(env)).to eq [404, {}, ['Ooops! We have not found:(']]
      end
    end
  end
end
