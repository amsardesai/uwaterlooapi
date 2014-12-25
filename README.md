uwaterlooapi
============

[![Build Status](https://travis-ci.org/amsardesai/uwaterlooapi.svg)](https://travis-ci.org/amsardesai/uwaterlooapi)
[![Code Climate](https://codeclimate.com/github/amsardesai/uwaterlooapi/badges/gpa.svg)](https://codeclimate.com/github/amsardesai/uwaterlooapi)
[![Test Coverage](https://codeclimate.com/github/amsardesai/uwaterlooapi/badges/coverage.svg)](https://codeclimate.com/github/amsardesai/uwaterlooapi)

RubyGem wrapper for the University of Waterloo OpenData API

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'middleman-protect-emails'
```

And then run:

    $ bundle

## Usage

To use this gem, you must first get an API key from http://api.uwaterloo.ca/.

```ruby
# Require the gem at the top of your ruby file
require 'uwaterlooapi'

# Initialize a new instance of the UWaterlooAPI
api = UWaterlooAPI.new '<your-api-key-goes-here>'

# Store an API query into a variable
current_weather = api.weather.current # '/weather/current'
uni_holidays = api.events.holidays # '/events/holidays'
info_sessions = api.terms.term(1149).infosessions # '/terms/1149/infosessions'
my_favorite_course = api.courses.subject('CS').catalog_number(247) # '/courses/CS/247'
my_favorite_course_schedule = my_favorite_course.schedule # '/courses/CS/247/schedule'

# Use the get method to manually retrieve the data and parse it
current_weather.get.temperature_24hr_max_c

# Or it will do it automatically for you
current_weather.temperature_24hr_max_c # does the same as above
uni_holidays.each do |holiday|
  puts holiday.name
end # this will print out every holiday
uni_holidays[0].name # this will print out the first holiday

# Requests will only be performed once for each query
my_favorite_course.title # => 'Software Engineering Principles'
my_favorite_course.url # => 'http://www.ucalendar.uwaterloo.ca/1415/COURSE/course-CS.html#CS247'

# Check metadata of request
my_favorite_course_schedule.get # Retrieves data from server
if my_favorite_course_schedule.meta(:status) == 204
  puts 'The schedule for this course cannot be found!'
end
```

For details regarding all API endpoints, go here: https://github.com/uWaterloo/api-documentation

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a [new pull request](../../pull/new/master)
