RSpec.describe Controller do
  subject do
    Controller.new do
      text: ['text/plain', ->(c) { c.to_s }],
      json: ['application/json', ->(c) { Oj.dump(c) }]
      end
    end
  end

  context 'when json response' do
    c = ('application/json')

  it 'successfully responds' do
    c =  Oj.dump(c)
    end
  end

  context 'when text response' do
      c = ('text/plain')

  it 'successfully responds' do
    c = c.to_s
    end
  end

  context 'when has router params' do
    request.params

  it 'successfully responds' do
    @request.params.merge!(env['router.params'] || {})
    end
  end
