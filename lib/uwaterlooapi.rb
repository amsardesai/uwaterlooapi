require 'httparty'
require 'uwaterlooapi/version'
require 'uwaterlooapi/routes'
require 'uwaterlooapi/query'

class UWaterlooAPI
  include UWaterlooAPI::Routes

  def initialize(api_key)
    get_base_routes.each do |route|
      self.class.send :define_method, route do
        UWaterlooAPI::Query.new "/#{route}", "/#{route}", api_key
      end
    end
  end

private

  def get_base_routes
    @base_routes ||= @@routes.map { |r| r.split('/')[1] }.uniq.map(&:to_sym)
  end
end
