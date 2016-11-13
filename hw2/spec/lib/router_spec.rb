require 'spec_helper'
require 'pry'

RSpec.describe Router do
  subject do
    Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name/edit/:field', ->(env) { [200, {}, ['url include argument'] ] }
    end
  end

  let(:env) { { 'REQUEST_METHOD' => 'GET'} }

  it 'url have argument' do
    env['REQUEST_PATH'] = '/test'
    subject.call(env)
    expect(env.keys).to include('PARAMS')
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      env['REQUEST_PATH'] = '/test'
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'and have url arguments' do
      before { env['REQUEST_PATH'] = '/post/vasya/edit/12' }

      it 'matches url', focue: true do 
        expect(subject.call(env)).to eq [200, {}, ['url include argument']]
      end

      it 'add arguments from url' do
        subject.call(env)
        expect(env['PARAMS'][:name]).to eq 'vasya'
        expect(env['PARAMS'][:field]).to eq '12'
      end

      it '404' do
        env['REQUEST_PATH'] = '/post/vasya/edit/12/qwe' 
        expect(subject.call(env)).to eq [404, {}, ['Page not found']]
      end
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end
