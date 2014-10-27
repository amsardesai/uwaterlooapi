require 'rspec'
require 'webmock/rspec'
require 'uwaterlooapi'

WebMock.disable_net_connect! allow_localhost: true
Dir.chdir File.dirname __FILE__

# This file was generated by the `rspec --init` command. Conventionally, all
# specs live under a `spec` directory, which RSpec adds to the `$LOAD_PATH`.
# Require this file using `require "spec_helper"` to ensure that it is only
# loaded once.
#
# See http://rubydoc.info/gems/rspec-core/RSpec/Core/Configuration
RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus

  config.before(:each) do
    stub_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey').
      to_return(status: 200, body: File.new('responses/timestamp.json'), headers: { 'Content-Type' => 'application/json; charset=utf-8' })
    stub_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey').
      to_return(status: 200, body: File.new('responses/courses.json'), headers: { 'Content-Type' => 'application/json; charset=utf-8' })
  end

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  #config.order = 'random'
end
