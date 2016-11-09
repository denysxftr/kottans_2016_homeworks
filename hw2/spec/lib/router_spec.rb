# rubocop:disable Metrics/BlockLength
RSpec.describe Router::Base do
  subject do
    Router::Base.new do
      get '/test', ->(_env) { [200, {}, ['get test']] }
      post '/test', ->(_env) { [200, {}, ['post test']] }
      get '/posts/:name', ->(_env) { [200, {}, ['post show page']] }
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

    it 'renders 404' do
      envs.each do |env|
        expect(subject.call(env))
          .to eq [404, {}, ['Ooops! We have not found:(']]
      end
    end
  end

  context 'under route with parameters' do
    context 'with one parameter' do
      let(:envs) do
        [
          { 'REQUEST_PATH' => '/posts/about_ruby', 'REQUEST_METHOD' => 'GET' },
          { 'REQUEST_PATH' => '/posts/43', 'REQUEST_METHOD' => 'GET' },
          { 'REQUEST_PATH' => 'posts/43', 'REQUEST_METHOD' => 'GET' }
        ]
      end

      it 'will recognize it' do
        envs.each do |env|
          expect(subject.call(env)[0]).to eq 200
          expect(subject.call(env)[2]).to eq ['post show page']
        end
      end

      it 'will return passed parameter' do
        envs.each do |env|
          expect(%w(about_ruby 43))
            .to include(subject.call(env)[1]['POST_NAME'])
        end
      end
    end

    context 'with nested parameters' do
      it 'will recognize it'
      it 'will return passed parameters for nested route'
    end
  end
end
