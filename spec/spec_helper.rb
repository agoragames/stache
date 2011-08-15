require 'bundler'
begin
  Bundler.setup
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'action_view'
require 'mustache'

module ActionView
  class Template
    module Foo
    end
  end
  class TemplateFoo
  end
end

require 'stache'
ENV["RAILS_ENV"] ||= 'test'
require 'dummy/config/environment'
require 'rspec/rails'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
