class WebConfig::Config
  attr_reader :host

  def self.load(file)
    host = file.readlines
    raise if host.empty?
    new(host: host)
  end

  def initialize(host: 'localhost')
    @host = host
  end
end
