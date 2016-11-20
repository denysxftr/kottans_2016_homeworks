require 'spec_helper'

RSpec.describe Hw3::Router do
  subject do
    Hw3::Router.new do
      get '/test', ->(_env) { [200, {}, ['get test']] }
      post '/test', ->(_env) { [200, {}, ['post test']] }
      get '/post/:name', ->(_env) { [200, {}, ['post show page']] }
      get '/any/:route/with/:any/:params', ->(_env) { [200, {}, ['any route page']] }
    end
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['get test']]
    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST' } }

    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when GETting parametrized resourse' do
    let(:random_name) { rand(36**10).to_s(36) }
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET' } }

    # due to random name - this spec covers both id and name cases
    it 'matches request to post resourse' do
      env['REQUEST_PATH'] = "/post/#{random_name}"
      expect(subject.call(env)).to eq [200, {}, ['post show page']]
    end

    it 'matches random request' do
      env['REQUEST_PATH'] = "/any/#{random_name}/with/#{random_name}/#{random_name}"
      expect(subject.call(env)).to eq [200, {}, ['any route page']]
    end

    it 'matches only word or/and digit names' do
      env['REQUEST_PATH'] = '/post/something/not/supported'
      expect(subject.call(env)).to eq [404, {}, ['not found']]
    end
  end

  context 'when requesting unavailabe resource(404)' do
    let(:env) { { 'REQUEST_PATH' => '/not/available', 'REQUEST_METHOD' => 'GET' } }
    it 'matches request' do
      expect(subject.call(env)).to eq [404, {}, ['not found']]
    end
  end
end
