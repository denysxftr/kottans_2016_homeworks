RSpec.describe HomeController do
  describe '#action' do
    it 'returns proc' do
      expect(described_class.action(:show)).to be_a(Proc)
    end

    it 'generated proc calls action' do
      expect(described_class.action(:show).call(Rack::MockRequest.env_for('/')))
        .to eq([200, {"Content-Type"=>"application/json"}, ["{}"]])
    end
  end


  describe 'request processing' do
    subject do
      described_class
        .action(action)
        .call(Rack::MockRequest.env_for('/?a=b').merge!(router_params))
    end

    let(:router_params) { {} }

    context '#show' do
      let(:action) { :show }

      it 'successfully responds' do
        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'application/json' },
            ['{"a":"b"}']
          ])
      end
    end

    context '#test' do
      let(:action) { :test }
      let(:router_params) { {'router.params' => {"name" => "qwerty"}} }

      it 'successfully responds' do

        expect(subject)
          .to eq([
            200,
            { 'Content-Type' => 'text/plain' },
            ['Name is: qwerty']
          ])
      end
    end

    context '#root' do
      let(:action) { :root }

      it 'successfully responds' do
        expect(subject[0]).to eq(200)
        expect(subject[1]).to eq({ "Content-Type"=>"text/html" })
        expect(subject[2]).to eq([File.read("./views/index.html.erb")])
      end
    end
  end
end
