require "spec_helper"

describe WebConfig do
  it "has a version number" do
    expect(WebConfig::VERSION).not_to be nil
  end
end
