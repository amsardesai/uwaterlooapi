require 'codeclimate-test-reporter'
CodeClimate::TestReporter.start

require 'rspec'
require 'webmock/rspec'
require 'uwaterlooapi'

WebMock.disable_net_connect! allow_localhost: true, allow: 'codeclimate.com'
Dir.chdir File.dirname __FILE__

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true

  config.before(:each) do
    stub_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey').
      to_return(status: 200, body: File.new('responses/timestamp.json'), headers: { 'Content-Type' => 'application/json; charset=utf-8' })
    stub_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey').
      to_return(status: 200, body: File.new('responses/courses.json'), headers: { 'Content-Type' => 'application/json; charset=utf-8' })
    stub_request(:get, 'https://api.uwaterloo.ca/v2/weather/current.json?format=json&key=testkey').
      to_return(status: 500)
  end

  config.order = 'random'
end
