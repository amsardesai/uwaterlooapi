require 'httparty'
require 'helpers/routes'
require 'helpers/uwaterlooapi_query'

class UWaterlooAPI
  VERSION = '0.0.1'
  include Routes

  def initialize(api_key)
    get_base_routes.each do |route|
      self.class.send :define_method, route do
        UWaterlooAPIQuery.new "/#{route}", "/#{route}", api_key
      end
    end
  end

private

  def get_base_routes
    @base_routes ||= @@routes.map { |r| r.split('/')[1] }.uniq.map(&:to_sym)
  end
end
