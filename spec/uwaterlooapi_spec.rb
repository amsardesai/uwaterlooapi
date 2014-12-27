require 'spec_helper'
describe UWaterlooAPI do
  let(:api) { UWaterlooAPI.new 'testkey' }

  describe '#new' do

    it 'returns a new UWaterlooAPI object' do
      expect(api).to be_an_instance_of(UWaterlooAPI)
    end

    it 'takes one parameter' do
      expect{ UWaterlooAPI.new }.to raise_exception ArgumentError
    end

    context 'queries' do

      let(:time) { api.server.time }

      it 'makes one request' do
        expect(time.timestamp).to eq 1414369440
        expect(time.datetime).to eq '2014-10-26T20:24:00-04:00'
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'returns a RecursiveOpenStruct after response is parsed' do
        expect(time.key_reset_time).to eq 1416978000
        expect(time.get).to be_an_instance_of RecursiveOpenStruct
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[0]).to be_an_instance_of RecursiveOpenStruct
      end

      it 'incrementally builds a query' do
        expect(api.terms).to be_an_instance_of UWaterlooAPI::Query
        expect(api.terms.term(1139)).to be_an_instance_of UWaterlooAPI::Query
        expect(api.terms.term(1139).subject('CS')).to be_an_instance_of UWaterlooAPI::Query
        expect(api.terms.term(1139).subject('CS').catalog_number(115)).to be_an_instance_of UWaterlooAPI::Query
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'makes one request over an iteration' do
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule.map { |s| s.topic }).to be_an_instance_of Array
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'can directly retrieve a deeply nested property' do
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[1].classes[0].instructors[0]).to eq 'Vasiga,Troy Michael John'
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[5].classes[0].date.end_time).to eq '11:20'
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[8].reserves.empty?).to eq true
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[14].class_number).to eq 5951
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[18].topic.nil?).to eq true
        expect(api.terms.term(1139).subject('CS').catalog_number(115).schedule[19].classes[0].date.is_closed).to eq false
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey')).to have_been_made.times 6
      end

      it 'makes one request per get call' do
        expect(time.get).to be_an_instance_of RecursiveOpenStruct
        expect(time.get).to be_an_instance_of RecursiveOpenStruct
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.times 2
      end

      it 'has a working respond_to? method' do
        expect(time.respond_to?(:get)).to eq true
        expect(time.respond_to?(:timestamp)).to eq true
        expect(time.respond_to?(:lolhi)).to eq false
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'has a working method_missing method' do
        expect{ time.hellobrah }.to raise_exception NoMethodError
        expect(time.timezone).to eq 'EDT'
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'allows retrieval of metadata' do
        expect{ time.meta(:status) }.to raise_exception RuntimeError
        time.get
        expect(time.meta(:status)).to eq 200
        expect(time.meta(:method_id)).to eq 1087
      end

      it 'can detect invalid method chains' do
        expect{ api.terms.get }.to raise_exception NoMethodError
        expect{ api.terms.term(1139).meta :status }.to raise_exception NoMethodError
        expect{ api.courses.catalog_number(1) }.to raise_exception NoMethodError
        expect{ api.foodservices.year(2013).announcements }.to raise_exception NoMethodError
      end

      it 'returns an error when the server has an error' do
        expect{ api.weather.current.get }.to raise_exception
      end

    end

    context 'list of valid routes' do

      it 'includes foodservices/menu' do
        expect(api.foodservices.menu).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/menu' do
        expect(api.foodservices.menu).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/notes' do
        expect(api.foodservices.notes).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/diets' do
        expect(api.foodservices.diets).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/outlets' do
        expect(api.foodservices.outlets).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/locations' do
        expect(api.foodservices.locations).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/watcard' do
        expect(api.foodservices.watcard).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/announcements' do
        expect(api.foodservices.announcements).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/products/{product_id}' do
        expect(api.foodservices.products.product_id(1386)).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/{year}/{week}/menu' do
        expect(api.foodservices.year(2014).week(2).menu).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/{year}/{week}/notes' do
        expect(api.foodservices.year(2014).week(2).notes).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes foodservices/{year}/{week}/announcements' do
        expect(api.foodservices.year(2014).week(2).announcements).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{subject}' do
        expect(api.courses.subject('MATH')).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{course_id}' do
        expect(api.courses.course_id(7407)).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{class_number}/schedule' do
        expect(api.courses.class_number(5377).schedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{subject}/{catalog_number}' do
        expect(api.courses.subject('MATH').catalog_number(115)).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{subject}/{catalog_number}/schedule' do
        expect(api.courses.subject('MATH').catalog_number(115).schedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{subject}/{catalog_number}/prerequisites' do
        expect(api.courses.subject('MATH').catalog_number(115).prerequisites).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes courses/{subject}/{catalog_number}/examschedule' do
        expect(api.courses.subject('MATH').catalog_number(115).examschedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes events' do
        expect(api.events).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes events/{site}' do
        expect(api.events.site('engineering')).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes events/{site}/{id}' do
        expect(api.events.site('engineering').id(1701)).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes events/holidays' do
        expect(api.events.holidays).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes news' do
        expect(api.news).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes news/{site}' do
        expect(api.news.site('engineering')).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes news/{site}/{id}' do
        expect(api.news.site('engineering').id(881)).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes weather/current' do
        expect(api.weather.current).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes terms/list' do
        expect(api.terms.list).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes terms/{term}/examschedule' do
        expect(api.terms.term(1139).examschedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes terms/{term}/{subject}/schedule' do
        expect(api.terms.term(1139).subject('MATH').schedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes terms/{term}/{subject}/{catalog_number}/schedule' do
        expect(api.terms.term(1139).subject('MATH').catalog_number(115).schedule).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes terms/{term}/infosessions' do
        expect(api.terms.term(1139).infosessions).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes resources/tutors' do
        expect(api.resources.tutors).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes resources/printers' do
        expect(api.resources.printers).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes resources/infosessions' do
        expect(api.resources.infosessions).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes resources/goosewatch' do
        expect(api.resources.goosewatch).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes codes/units' do
        expect(api.codes.units).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes codes/terms' do
        expect(api.codes.terms).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes codes/groups' do
        expect(api.codes.groups).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes codes/subjects' do
        expect(api.codes.subjects).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes codes/instructions' do
        expect(api.codes.instructions).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes buildings/list' do
        expect(api.buildings.list).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes buildings/{building_code}' do
        expect(api.buildings.building_code('MHR')).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes buildings/{building}/{room}/courses' do
        expect(api.buildings.building('MC').room(2038).courses).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes api/usage' do
        expect(api.api.usage).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes api/services' do
        expect(api.api.services).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes api/methods' do
        expect(api.api.methods).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes api/versions' do
        expect(api.api.versions).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes api/changelog' do
        expect(api.api.changelog).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes server/time' do
        expect(api.server.time).to be_an_instance_of UWaterlooAPI::Query
      end

      it 'includes server/codes' do
        expect(api.server.codes).to be_an_instance_of UWaterlooAPI::Query
      end

    end
  end
end
