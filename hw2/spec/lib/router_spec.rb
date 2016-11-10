RSpec.describe Router do
  routes = [
    { path: '/posts', expect: '/posts' },
    { path: '/posts/:a', expect: '/posts/a' },
    { path: '/posts/:a/ab', expect: '/posts/a/ab' },
    { path: '/posts/:a/:b/:c', expect: '/posts/a/b/c' }
  ]

  subject do
    Router.new do
      routes.each do |route|
        get route[:path], ->(_) { [200, {}, ["GET #{route[:expect]}"]] }
        post route[:path], ->(_) { [200, {}, ["POST #{route[:expect]}"]] }
        patch route[:path], ->(_) { [200, {}, ["PATCH #{route[:expect]}"]] }
        put route[:path], ->(_) { [200, {}, ["PUT #{route[:expect]}"]] }
        delete route[:path], ->(_) { [200, {}, ["DELETE #{route[:expect]}"]] }
      end
    end
  end

  %w(GET POST PATCH PUT DELETE).each do |http_method|
    context "when request is #{http_method}" do
      routes.each do |route|
        it "matches #{route[:path]} request" do
          env = {
            'REQUEST_PATH' => route[:expect],
            'REQUEST_METHOD' => http_method
          }
          response = [200, {}, ["#{http_method} #{route[:expect]}"]]
          expect(subject.call(env)).to eq(response)
        end
      end

      it 'returns 404 if path not found' do
        env = { 'REQUEST_PATH' => '/test', 'REQUEST_METHOD' => http_method }
        expect(subject.call(env)).to eq([404, {}, ['page not found']])
      end
    end
  end
end
