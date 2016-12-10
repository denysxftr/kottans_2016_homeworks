require 'spec_helper'

RSpec.describe WebConfig::Router do
  subject do
    WebConfig::Router.new do
      get '/test', ->(env) { [200, {}, ['get test']] }
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/post/:name/edit/:field', ->(env) { [200, {}, ['url include argument'] ] }
      class TestController
        def self.action(action_name)
          ->(env) { [200, {}, ['posts test']] }
        end
      end

      get '/posts', 'test#action'
      
    end  

  end

  shared_examples 'for non-existent routes' do
    it 'not found routes' do
      expect(subject.call(unknow_env)).to eq [404, {}, ['Page not found']]
    end
  end

  context 'when request is GET' do
    include_examples 'for non-existent routes'

    let(:unknow_env) { { 'REQUEST_METHOD' => 'GET', 'REQUEST_PATH' => '/olol/ololo/ololol/ololo'} }
    let(:env) { { 'REQUEST_METHOD' => 'GET', 'REQUEST_PATH' => '/test'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end

    context 'have url arguments' do
      before { env['REQUEST_PATH'] = '/post/vasya/edit/12' }

      it 'matches url' do 
        expect(subject.call(env)).to eq [200, {}, ['url include argument']]
      end
    end

    context 'have controller' do
      before  { env['REQUEST_PATH'] = '/posts' }

      it 'matches controller' do
        expect(subject.call(env)).to eq [200, {}, ['posts test']]
      end
    end
  end

  context 'when request is POST' do
    include_examples 'for non-existent routes'

    let(:unknow_env) { { 'REQUEST_METHOD' => 'POST', 'REQUEST_PATH' => '/olol/ololo/ololol/ololo'} }
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end
end