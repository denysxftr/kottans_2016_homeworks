require "spec_helper"
require "./lib/controuter"

describe Controuter do
  it "has a version number" do
    expect(Controuter::VERSION).not_to be nil
  end
end

describe Controuter::Router do
  subject do
    Controuter::Router.new do
      get '/test', 'tests#show'
    end
  end

  context "when page not found" do
    let(:env) { { 'REQUEST_PATH' => '/wrong-page', 'REQUEST_METHOD' => 'GET'} }
    it 'matches request' do
      expect(subject.call(env)).to eq [404, {}, ['404']]
    end
  end
end

describe Controuter::Router do
  subject do
    Controuter::Router.new do
      get '/page', 'tests#show'
    end

    TestsController = ->(_var){"show"}
  end

  context "simulating controller action" do
    let(:env) { { 'REQUEST_PATH' => '/page', 'REQUEST_METHOD' => 'GET'} }

    it do
      expect(subject.call(env)).to eq "show"
    end
  end
end
