require 'spec_helper'

describe MyRouter do
  subject do
    MyRouter::Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page param']] }
      get '/hello/:name', ->(env) { [200, {}, ["Hello #{env['router.params']['name']}!"]]}
      get '/posts/:post_id/:post_name', ->(env) { [200, {}, ["Post id: #{env['router.params']['post_id']} | post name: #{env['router.params']['post_name']}"]] }
    end
  end

  it 'has a version number' do
    expect(MyRouter::VERSION).not_to be nil
  end

  context 'when request is GET to /wrong_url path' do
    let(:env) { { 'REQUEST_PATH' => '/wrong_url', 'REQUEST_METHOD' => 'GET'} }

    it 'returns 404' do
      expect(subject.call(env)).to eq [404, {}, ['not found']]
    end
  end

  context 'when request is GET to /test path' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is GET to /post path with param' do
    let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post show page param']]
    end
  end

  context 'when request is POST to /wrong_url' do
    let(:env) { { 'REQUEST_PATH' => '/wrong_url', 'REQUEST_METHOD' => 'POST'} }

    it 'returns 404' do
      expect(subject.call(env)).to eq [404, {}, ['not found']]
    end
  end

  context 'when request is POST to /test' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when request is GET with param to /hello' do
    let(:env) { { 'REQUEST_PATH' => '/hello/John', 'REQUEST_METHOD' => 'GET' } }

    it 'extracts param from request' do
      expect(subject.call(env)).to eq [200, {}, ['Hello John!']]
    end
  end

  context 'when request is GET with multiple params to /posts' do
    let(:env) { { 'REQUEST_PATH' => '/posts/1/about_ruby', 'REQUEST_METHOD' => 'GET' } }

    it 'extracts params from request' do
      expect(subject.call(env)).to eq [200, {}, ['Post id: 1 | post name: about_ruby']]
    end
  end

end
