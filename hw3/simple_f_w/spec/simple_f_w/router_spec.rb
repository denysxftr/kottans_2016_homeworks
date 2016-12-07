require 'spec_helper'

describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when page not found' do
    let(:env) { { 'REQUEST_PATH' => '/test1', 'REQUEST_METHOD' => 'GET'} }

    it 'returns 404' do
      expect(subject.call(env)).to eq [404, {}, ['Not Found']]
    end
  end

  context 'when request has Pattern: /post/about_ruby' do
    let(:env) { { 'REQUEST_PATH' => '/post/about_ruby', 'REQUEST_METHOD' => 'GET'} }

    it 'returns /post/about_ruby' do
      expect(subject.call(env)).to eq [200, {}, ['post show page']]
    end
  end

  context 'when request has Pattern: /post/43' do
    let(:env) { { 'REQUEST_PATH' => '/post/43', 'REQUEST_METHOD' => 'GET'} }

    it 'returns /post/43' do
      expect(subject.call(env)).to eq [200, {}, ['post show page']]
    end
  end
end
