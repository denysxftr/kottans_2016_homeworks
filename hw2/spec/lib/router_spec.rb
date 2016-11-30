RSpec.describe Router do
  before(:all) do
    class TestsController < Controller
      def show
        response(:json, params)
      end

      def test
        response(:text, "Required method #{request.request_method}")
      end
    end
  end

  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }

      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
      get '/post/:name/:name', ->(env) { [200, {}, ['nested in a row post show page']] }
      get '/post/:name/:name/comments/:name', ->(env) { [200, {}, ['nested in a row and not in a row post show page']] }
      post '/test/some_path', ->(env) { [200, {}, ['post some_path page']] }

      get '/comments/:name/:other_one', 'tests#show'
      get '/testing', 'tests#test'
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET', 'params' => {} } }

    it 'returns 404 error for missing path' do
      expect(subject.call({ 'REQUEST_PATH' => '/not_found_path', 'REQUEST_METHOD' => 'GET'})).to eq [404, {}, ['not found']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'when request is nested /post/:name' do
      it 'matches request if nested' do
        env['REQUEST_PATH'] = '/post/some_string'
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end

      it 'not matches request if deep nested post url' do
        env['REQUEST_PATH'] = '/post/some_string/string/string'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end

      it 'not matches request if url has //' do
        env['REQUEST_PATH'] = '/post//some_string'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end
    end

    context 'when request is nested /post/:name/:name' do
      it 'matches request if nested' do
        env['REQUEST_PATH'] = '/post/some_path/some_path'
        expect(subject.call(env)).to eq [200, {}, ['nested in a row post show page']]
      end

      it 'not matches request if url is not nested but "post"' do
        env['REQUEST_PATH'] = '/post/'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end
    end

    context 'when request is nested /post/:name/:name/comments/:name' do
      it 'matches request if nested' do
        env['REQUEST_PATH'] = '/post/some_path/some_path/comments/some_path'
        expect(subject.call(env)).to eq [200, {}, ['nested in a row and not in a row post show page']]
      end

      it 'matches request if nested and ends on /' do
        env['REQUEST_PATH'] = '/post/some_path/some_path/comments/some_path'
        expect(subject.call(env)).to eq [200, {}, ['nested in a row and not in a row post show page']]
      end

      it 'not matches request if url is not nested but "post" and "comments"' do
        env['REQUEST_PATH'] = '/post/:name/:name/comments/'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end

      it 'not matches request if url has not "comments"' do
        env['REQUEST_PATH'] = '/post/:name/:name/some_path/:name'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end

      it 'not matches request if url is nested more than need ' do
        env['REQUEST_PATH'] = '/post/:name/:name/some_path/:name/path'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end
    end

    context 'when request is "/testing" -> "tests#test"' do
      it 'matches request' do
        env['REQUEST_PATH'] = '/testing'
        env['rack.input'] = Rack::Request.new({})
        expect(subject.call(env)).to eq [200, {'Content-Type'=>'text/plain'}, ['Required method GET']]
      end
    end

    context 'when request is "/post/:name/:other_one" -> "tests#show"' do
      it 'matches request' do
        env['REQUEST_PATH'] = '/comments/comment/other'
        env['rack.input'] = Rack::Request.new({})
        expect(subject.call(env)).to eq [200, {'Content-Type'=>'application/json'}, ["{\"name\":\"comment\",\"other_one\":\"other\"}"]]
      end
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'returns 404 error for missing path' do
      expect(subject.call({ 'REQUEST_PATH' => '/not_found_path', 'REQUEST_METHOD' => 'POST'})).to eq [404, {}, ['not found']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end

    context 'when request is direct /test/some_path' do
      it 'matches request "/test/some_path"' do
        env['REQUEST_PATH'] = '/test/some_path'
        expect(subject.call(env)).to eq [200, {}, ['post some_path page']]
      end

      it 'not matches request "/test/some_path/path"' do
        env['REQUEST_PATH'] = '/test/some_path/path'
        expect(subject.call(env)).to eq [404, {}, ['not found']]
      end
    end
  end
end
