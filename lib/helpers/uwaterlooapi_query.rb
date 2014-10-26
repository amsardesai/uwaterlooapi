require 'recursive-open-struct'

class UWaterlooAPIQuery
  include Routes

  def initialize(cur_route, cur_url, api_key)
    @api_key = api_key
    @cur_url = cur_url
    @cur_route = cur_route
    @retrieved_url = ''
    @response = @meta = nil

    routes = @@routes.select { |s| s.start_with?(cur_route) }.
      map { |s| s[@cur_route.length..-1] }.
      join.split('/').uniq.delete_if(&:empty?)

    # Without methods
    routes.reject { |r| r =~ /^\{.*\}$/ }.
      map(&:to_sym).each do |route|
      
      self.class.send :define_method, route do
        if is_in_routes?("#{@cur_route}/#{route}")
          UWaterlooAPIQuery.new "#{@cur_route}/#{route}", "#{@cur_url}/#{route}", api_key
        else
          raise NoMethodError
        end
      end
    end

    # With methods
    routes.select { |r| r =~ /^\{.*\}$/ }.
      map { |r| r.delete('{}') }.
      map(&:to_sym).each do |route|

      self.class.send :define_method, route do |value|
        raise ArgumentError if value.empty?
        if is_in_routes?("#{@cur_route}/{#{route}}")
          UWaterlooAPIQuery.new "#{@cur_route}/{#{route}}", "#{@cur_url}/#{value}", api_key
        else
          raise NoMethodError
        end
      end
    end
  end

  # Get meta variables
  def meta(var)
    if @meta
      @meta[var.to_s]
    else
      raise "No request has been made yet, so meta data is not available."
    end
  end

  def method_missing(method, *args, &block)
    # Get data from API server
    get unless just_made_request

    if @response.data.respond_to? method
      @response.data.send method, *args, &block
    else
      super
    end
  end

  def respond_to?(method, include_private = false)
    # Get data from API server
    get unless just_made_request

    if @response.data.respond_to? method
      true
    else
      super
    end
  end

  def get
    raise NoMethodError unless is_full_route? @cur_route
    @retrieved_url = @cur_url
    response = HTTParty.get("https://api.uwaterloo.ca/v2#{@cur_url}.json", { query: { key: @api_key, format: 'json' } })
    case response.code
    when 400...600
      raise "UWaterloo API Server returned a #{response.code} error"
    end
    @response = RecursiveOpenStruct.new response, recurse_over_arrays: true
    @meta = response['meta']
    @response.data
  end

  private

  def just_made_request
    @retrieved_url == @cur_url
  end

  def is_in_routes?(substring)
    @@routes.any? { |s| s.start_with?(substring) }
  end

  def is_full_route?(substring)
    @@routes.include? substring
  end

end
