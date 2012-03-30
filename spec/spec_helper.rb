$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'webmock/rspec'
require 'vcr'
require 'reggie'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
end

EDGECAST_ACCOUNT = YAML.load open File.join File.dirname(__FILE__), "config", "edgecast.yml"

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr'
  config.filter_sensitive_data('CUSTOMER_ID') { EDGECAST_ACCOUNT['customer_id'] }
  config.filter_sensitive_data('TOKEN') { EDGECAST_ACCOUNT['token'] }
  config.hook_into :webmock
end