RSpec.describe Router do
  subject do
    Router.new do
      get '/post/:name', ->(headers) { [200, headers, ['get post show page']] }
      get '/test',       ->(headers) { [200, headers, ['get test']] }
      post '/test',      ->(headers) { [200, headers, ['post test']] }
    end
  end

  let(:headers) { { 'Content-Type' => 'text/plain' } }

  context 'when request is GET /test' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, headers, ['get test']]
    end
  end

  context 'when request is GET /post/:name' do
    let(:env) { { 'REQUEST_PATH' => path, 'REQUEST_METHOD' => 'GET' } }

    context 'with name as a string' do
      let(:path) { '/post/about_ruby' }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, headers, ['get post show page']]
      end
    end

    context 'with name as an integer' do
      let(:path) { '/post/45' }

      it 'matches request' do
        expect(subject.call(env)).to eq [200, headers, ['get post show page']]
      end
    end
  end

  context 'when request is POST /test' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, headers, ['post test']]
    end
  end

  context 'when path does not exist' do
    let(:not_found) { [404, headers, ['Not Found']] }

    context 'for GET request' do
      let(:env) { { 'REQUEST_PATH' => path, 'REQUEST_METHOD' => 'GET' } }

      context 'with /wrong_path path' do
        let(:path) { '/wrong_path' }

        it 'returns 404' do
          expect(subject.call(env)).to eq not_found
        end
      end

      context 'with /post/:name/test path' do
        let(:path) { '/post/about_ruby/test' }

        it 'returns 404' do
          expect(subject.call(env)).to eq not_found
        end
      end

      context 'with /post/:name/test path' do
        let(:path) { '/post/:name' }

        it 'returns 404' do
          expect(subject.call(env)).to eq not_found
        end
      end
    end

    context 'for POST request' do
      let(:env) { { 'REQUEST_PATH' => path, 'REQUEST_METHOD' => 'POST' } }

      context 'with /wrong_path path' do
        let(:path) { '/wrong_path' }

        it 'returns 404' do
          expect(subject.call(env)).to eq not_found
        end
      end

      context 'with /post/:name/test path' do
        let(:path) { '/post/about_ruby' }

        it 'returns 404' do
          expect(subject.call(env)).to eq not_found
        end
      end
    end
  end
end
