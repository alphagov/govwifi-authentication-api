require "rack/test"
require "rspec"
require "simplecov"

ENV["RACK_ENV"] = "test"

require File.expand_path "../app.rb", __dir__

module RSpecMixin
  include Rack::Test::Methods
  def app
    described_class
  end
end

SimpleCov.start

RSpec.configure { |c| c.include RSpecMixin }
