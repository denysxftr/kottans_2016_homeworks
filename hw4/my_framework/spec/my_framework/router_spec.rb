require 'spec_helper'

describe MyFramework::Router do
  subject do
    described_class.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
      get '/blog/:page_id/posts/:post_id', (lambda do |env|
        [200, {}, ["get blog page: #{env['request_vars']['page_id']} post: #{env['request_vars']['post_id']}"]]
      end)

      class TestController
        def self.action(action_name)
          ->(env) { [200, {}, ["test controller #{action_name} action"]] }
        end
      end

      get '/testaction', 'test#action'
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'when request to non existen page' do
      let(:env) { { 'REQUEST_PATH' => '/not_exist', 'REQUEST_METHOD' => 'GET' } }

      it 'returns 404 for non existen pages' do
        expect(subject.call(env)).to eq [404, {}, ['Page not found']]
      end
    end

    context 'when request with param' do
      let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET' } }

      it 'matches request with params' do
        expect(subject.call(env)).to eq [200, {}, ['post show page']]
      end
    end

    context 'when request with multiple params', get_multiple_params: true do
      let(:env) { { 'REQUEST_PATH' => '/blog/vasya/posts/about_ruby', 'REQUEST_METHOD' => 'GET' } }

      it 'matches request with params and substitutes them' do
        expect(subject.call(env)).to eq [200, {}, ['get blog page: vasya post: about_ruby']]
      end
    end

    context 'when route contains action' do
      let(:env) { { 'REQUEST_PATH' => '/testaction', 'REQUEST_METHOD' => 'GET' } }

      it 'returns controller action' do
        expect(subject.call(env)).to eq [200, {}, ['test controller action action']]
      end
    end
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
