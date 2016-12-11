require 'spec_helper'

RSpec.describe Hola::Router do
  subject do
    Hola::Router.new do
      get '/', ->(env) { [200, {}, ['root path']] }
      post '/', ->(env) { [200, {}, ['root path']] }
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/blog/post/:id', ->(env) { [200, {}, ['post show page']] }
    end
  end

  shared_examples 'when request is unknown' do
    let(:unknown) { {'REQUEST_PATH' => '/oops', 'REQUEST_METHOD' => 'GET'} }

    it 'returns 404' do
      expect(subject.call(unknown)).to eq [404, {}, ['Not found']]
    end
  end

  context 'when request is GET' do
    include_examples 'when request is unknown'
    let(:root) { { 'REQUEST_PATH' => '/', 'REQUEST_METHOD' => 'GET'} }
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'} }
    let(:pattern) { { 'REQUEST_PATH' => '/blog/post/2', 'REQUEST_METHOD' => 'GET'} }

    it 'root request' do
      expect(subject.call(root)).to eq [200, {}, ['root path']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    it 'matches rout with pattern' do
      expect(subject.call(pattern)).to eq [200, {}, ['post show page']]
    end
  end

  context 'when request is POST' do
    include_examples 'when request is unknown'
    let(:root) { { 'REQUEST_PATH' => '/', 'REQUEST_METHOD' => 'POST'} }
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'root request' do
      expect(subject.call(root)).to eq [200, {}, ['root path']]
    end

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
