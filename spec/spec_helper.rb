# spec/spec_helper.rb
require 'rack/test'
require 'rspec'
require 'json'

ENV['RACK_ENV'] = 'test'

require File.expand_path '../../server.rb', __FILE__

module RSpecMixin
  include Rack::Test::Methods
  def app() Sinatra::Application end
end

# For RSpec 2.x
RSpec.configure { |c| c.include RSpecMixin }
