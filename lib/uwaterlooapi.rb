require 'httparty'
require '~/repos/uwaterlooapi/lib/helpers/routes'
require '~/repos/uwaterlooapi/lib/helpers/uwaterlooapi_query'

class UWaterlooAPI
  include Routes

  def initialize(api_key)
    @@routes.map { |r| r.split('/')[1] }.uniq.map(&:to_sym).each do |route|
      self.class.send :define_method, route do
        UWaterlooAPIQuery.new "/#{route}", "/#{route}", api_key
      end
    end
  end

end
