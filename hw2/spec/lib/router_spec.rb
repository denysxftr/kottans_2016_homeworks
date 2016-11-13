RSpec.describe Router do
  subject do
    Router.new do
      # posts
      get     '/posts',                    ->(env) { [200, {}, ['shows the posts'   ]] }             # /posts
      post    '/posts',                    ->(env) { [200, {}, ['creates a post'    ]] }             # /posts
      get     '/posts/:name',              ->(env) { [200, {}, ['shows a post'      ]] }             # /posts/1
      put     '/posts/:name',             ->(env) { [200, {}, ['updates a post'    ]] }             # /posts/1
      delete  '/posts/:name',              ->(env) { [200, {}, ['destroys a post'   ]] }             # /posts/1

      # comments that nested in post
      get     '/posts/:name/comments',     ->(env) { [200, {}, ['shows the comments']] }              # /posts/1/comments
      post    '/posts/:name/comments',    ->(env) { [200, {}, ['creates a comment' ]] }              # /posts/1/comments
      get     '/posts/:name/comments/:id', ->(env) { [200, {}, ['shows a comment'   ]] }              # /posts/1/comments/1
      put     '/posts/:name/comments/:id', ->(env) { [200, {}, ['updates a comment' ]] }              # /posts/1/comments/1
      delete  '/posts/:name/comments/:id', ->(env) { [200, {}, ['destroys a comment']] }              # /posts/1/comments/1
    end
  end

  let(:env) { env = { 'REQUEST_PATH' => '/', 'REQUEST_METHOD' => '' } }

  describe 'positive specs for' do
    describe 'posts routes' do
      it 'shows a posts with GET' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/posts'
        expect(subject.call(env)).to eq [200, {}, ['shows the posts']]
      end

      it 'creates a post with POST' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'POST', '/posts'
        expect(subject.call(env)).to eq [200, {}, ['creates a post']]
      end

      context 'shows a post with GET' do
        it 'by identify name' do
          env['REQUEST_PATH'], env['REQUEST_METHOD'] = '/posts/12', 'GET'
          expect(subject.call(env)).to eq [200, {}, ['shows a post']]
        end

        it 'by identify id' do
          env['REQUEST_PATH'], env['REQUEST_METHOD'] = '/posts/lol', 'GET'
          expect(subject.call(env)).to eq [200, {}, ['shows a post']]
        end
      end

      it 'updates a post with PUT' do
        env['REQUEST_PATH'], env['REQUEST_METHOD'] = '/posts/lol', 'PUT'
        expect(subject.call(env)).to eq [200, {}, ['updates a post']]
      end

      it 'destroys a post with DELETE' do
        env['REQUEST_PATH'], env['REQUEST_METHOD'] = '/posts/lol', 'DELETE'
        expect(subject.call(env)).to eq [200, {}, ['destroys a post']]
      end
    end

    describe 'comments routes nested in post' do
      it 'shows the comments with GET' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/posts/1/comments'
        expect(subject.call(env)).to eq [200, {}, ['shows the comments']]
      end

      it 'creates a comment with POST' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'POST', '/posts/1/comments'
        expect(subject.call(env)).to eq [200, {}, ['creates a comment']]
      end

      it 'shows a comment with GET' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/posts/1/comments/1'
        expect(subject.call(env)).to eq [200, {}, ['shows a comment']]
      end

      it 'updates a comment with PUT' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'PUT', '/posts/1/comments/1'
        expect(subject.call(env)).to eq [200, {}, ['updates a comment']]
      end

      it 'destroys a comment with DELETE' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'DELETE', '/posts/1/comments/1'
        expect(subject.call(env)).to eq [200, {}, ['destroys a comment']]
      end
    end
  end

  describe 'negative specs' do
    context 'not found for' do
      it 'undefined route' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/videos'
        expect(subject.call(env)).to eq [404, {}, ['Not found :(']]
      end

      it 'route with incorrect parent path' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/videos/12'
        expect(subject.call(env)).to eq [404, {}, ['Not found :(']]
      end

      it 'route with incorrect child path' do
        env['REQUEST_METHOD'], env['REQUEST_PATH']= 'GET', '/posts/:id'
        expect(subject.call(env)).to eq [404, {}, ['Not found :(']]
      end
    end
  end

end