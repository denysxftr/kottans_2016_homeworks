require 'spec_helper'

RSpec.describe Brouter do

  class TestsController < Controller
    def test
      response(200, :text, "Request method: #{request.request_method}")
    end
  end

  class CommentsController < Controller
    def show
      response(200, :json, 'List of comments')
    end
  end

  subject do
    Brouter::Router.new do
      get '/test', 'tests#test'
      post '/test', ->(env) { [200, {}, ['post test']] }
      get '/posts', ->(env) { [200, {}, ['posts show page']] }
      get '/post/:name', ->(env) { [200, {}, ['post show page']] }
      get '/post/:name/edit', ->(env) { [200, {}, ['edit post show page']] }
      get '/post/:name/comments', 'comments#show'
    end
  end

  it "has a version number" do
    expect(Brouter::VERSION).not_to be nil
  end

  context 'when request is GET' do
    let(:env) { { 'REQUEST_PATH' => '/posts', 'REQUEST_METHOD' => 'GET'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['posts show page']]
    end

    it 'matches patterned request' do
      ['43', 'about_ruby'].each do |path|
        env = { 'REQUEST_PATH' => "/post/#{path}", 'REQUEST_METHOD' => 'GET'}
        expect(subject.call(env)).to eq [200, {}, ['post show page']]

        env = { 'REQUEST_PATH' => "/post/#{path}/edit", 'REQUEST_METHOD' => 'GET'}
        expect(subject.call(env)).to eq [200, {}, ['edit post show page']]
      end
    end

    it 'saves router params' do
      env = { 'REQUEST_PATH' => "/post/frog", 'REQUEST_METHOD' => 'GET' }
      subject.call(env)
      expect(env['router.params']).to eq({'name' => 'frog'})

    end
  end

  context 'when request is POST' do
    let(:env) { { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'POST'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [200, {}, ['post test']]
    end
  end

  context 'when request does not match the routes' do
    it 'returns 404 when request path does not exist in the routes' do
      ['GET', 'POST'].each do |method|
        ['/nothing_here', '/post/something/oops'].each do |path|
          env = { 'REQUEST_PATH' => path, 'REQUEST_METHOD' => method }
          expect(subject.call(env)).to eq [404, {}, ['not found']]
        end
      end
    end
  end

  context 'when rack app is called with controller' do
    it 'gets test page' do
      env = Rack::MockRequest.env_for.merge({ 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => 'GET'})
      expect(subject.call(env)).to eq [200, {'Content-Type' => 'text/plain'}, ['Request method: GET']]
    end

    it 'gets post comments page' do
      env = Rack::MockRequest.env_for.merge({ 'REQUEST_PATH' => '/post/why_it_does_not_work/comments', 'REQUEST_METHOD' => 'GET'})
      expect(subject.call(env)).to eq [200, {'Content-Type' => 'application/json'}, ['"List of comments"']]
    end
  end
end
