require 'httparty'
require 'json'
require '~/repos/uwaterlooapi/lib/helpers/routes'

class UWaterlooAPI
  include Routes

  def initialize(api_key)
    @api_key = api_key

  end

  def hello
    get('/foodservices/menu')
  end


  private
  def get(url)
    HTTParty.get(api_url + url, { query: { key: @api_key, format: 'json' } })
  end

  def api_url
    'https://api.uwaterloo.ca/v2'
  end
end
