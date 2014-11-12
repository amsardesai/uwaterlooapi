require 'recursive-open-struct'

class UWaterlooAPIQuery
  include Routes
  
  def initialize(cur_route, cur_url, api_key)
    @api_key = api_key
    @cur_url = cur_url
    @cur_route = cur_route
    @retrieved_url = ''
    @response = @meta = nil

    # Define methods without parameters
    get_next_routes_without_params.each do |route|
      self.class.send :define_method, route do
        raise NoMethodError unless is_in_routes?("#{@cur_route}/#{route}")
        UWaterlooAPIQuery.new "#{@cur_route}/#{route}", "#{@cur_url}/#{route}", @api_key
      end
    end

    # Define methods with parameters
    get_next_routes_with_params.each do |route|
      self.class.send :define_method, route do |value|
        raise ArgumentError if ["", 0].include? value
        raise NoMethodError unless is_in_routes?("#{@cur_route}/{#{route}}")
        UWaterlooAPIQuery.new "#{@cur_route}/{#{route}}", "#{@cur_url}/#{value}", @api_key
      end
    end
  end

  # Get meta variables
  def meta(var)
    raise NoMethodError unless is_full_route? @cur_route
    raise "No request has been made yet, so meta data is not available." unless @meta
    @meta[var.to_s]
  end

  # Get data from server
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

private

  def just_made_request
    @retrieved_url == @cur_url
  end

  def get_next_routes
    @next_routes ||= @@routes.
      select { |s| s.start_with?(@cur_route) }.
      map { |s| s[@cur_route.length..-1] }.
      join.split('/').uniq.delete_if(&:empty?)
  end

  def get_next_routes_without_params
    @next_routes_without_params ||= get_next_routes.
      reject { |r| r =~ /^\{.*\}$/ }.map(&:to_sym)
  end

  def get_next_routes_with_params
    @next_routes_with_params ||= get_next_routes.
      select { |r| r =~ /^\{.*\}$/ }.
      map { |r| r.delete('{}') }.map(&:to_sym)
  end

  def is_in_routes?(substring)
    @@routes.any? { |s| s.start_with?(substring) }
  end

  def is_full_route?(substring)
    @@routes.include? substring
  end

end
