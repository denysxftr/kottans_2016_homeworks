require './main'

RSpec.describe Router do

  context 'when page not found' do
    let(:env) { { 'REQUEST_PATH' => '/wrong-page', 'REQUEST_METHOD' => 'GET'} }

    it 'matches request' do
      expect(Application.call(env)).to eq [404, {}, ['404']]
    end
  end

  context 'when request is GET & PATH is home page' do
    let(:env) {{ 'REQUEST_PATH' => '/', 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/'}}

    it 'matches request' do
      expect(Application.call(env)).to eq [200, {"Content-Type"=>"text/html"}, ["<h1>Home Page</h1><br><a href='/pages/1'>Page 1</a><br><a href='/pages/2'>Page 2</a>"]]
    end
  end

  context 'when request is GET & PATH is some page' do
    let(:env) {{ 'REQUEST_PATH' => '/pages/1', 'REQUEST_METHOD' => 'GET', 'PATH_INFO' => '/pages/1'}}

    it 'matches request' do
      expect(Application.call(env)).to eq [200, {"Content-Type"=>"text/html"}, ["/pages/1"]]
    end
  end
end
