require 'spec_helper'
describe UWaterlooAPI do
  before :each do
    @api = UWaterlooAPI.new 'testkey'
  end

  describe '#new' do
    it 'returns a new UWaterlooAPI object' do
      expect(@api).to be_an_instance_of(UWaterlooAPI)
    end

    it 'takes one parameter' do
      expect{ UWaterlooAPI.new }.to raise_exception ArgumentError
    end

    it 'returns a UWaterlooAPIQuery object for foodservices' do
      expect(@api.foodservices).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for courses' do
      expect(@api.courses).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for events' do
      expect(@api.events).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for news' do
      expect(@api.news).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for weather' do
      expect(@api.weather).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for terms' do
      expect(@api.terms).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for resources' do
      expect(@api.resources).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for codes' do
      expect(@api.codes).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for buildings' do
      expect(@api.buildings).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for api' do
      expect(@api.api).to be_an_instance_of UWaterlooAPIQuery
    end

    it 'returns a UWaterlooAPIQuery object for server' do
      expect(@api.server).to be_an_instance_of UWaterlooAPIQuery
    end

    context 'queries' do
      before :each do
        @time = @api.server.time
      end

      it 'makes one request' do
        expect(@time.timestamp).to eq 1414369440
        expect(@time.datetime).to eq '2014-10-26T20:24:00-04:00'
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'returns a RecursiveOpenStruct after response is parsed' do
        expect(@time.key_reset_time).to eq 1416978000
        expect(@time.get).to be_an_instance_of RecursiveOpenStruct
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[0]).to be_an_instance_of RecursiveOpenStruct
      end

      it 'incrementally builds a query' do
        expect(@api.terms.term(1139)).to be_an_instance_of UWaterlooAPIQuery
        expect(@api.terms.term(1139).subject('CS')).to be_an_instance_of UWaterlooAPIQuery
        expect(@api.terms.term(1139).subject('CS').catalog_number(115)).to be_an_instance_of UWaterlooAPIQuery
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule).to be_an_instance_of UWaterlooAPIQuery
      end

      it 'makes one request over an iteration' do
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule.map { |s| s.topic }).to be_an_instance_of Array
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'can directly retrieve a deeply nested property' do
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[1].classes[0].instructors[0]).to eq 'Vasiga,Troy Michael John'
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[5].classes[0].date.end_time).to eq '11:20'
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[8].reserves.empty?).to eq true
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[14].class_number).to eq 5951
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[18].topic.nil?).to eq true
        expect(@api.terms.term(1139).subject('CS').catalog_number(115).schedule[19].classes[0].date.is_closed).to eq false
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/terms/1139/CS/115/schedule.json?format=json&key=testkey')).to have_been_made.times 6
      end

      it 'makes one request per get call' do
        expect(@time.get).to be_an_instance_of RecursiveOpenStruct
        expect(@time.get).to be_an_instance_of RecursiveOpenStruct
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.times 2
      end

      it 'has a working respond_to? method' do
        expect(@time.respond_to?(:get)).to eq true
        expect(@time.respond_to?(:timestamp)).to eq true
        expect(@time.respond_to?(:lolhi)).to eq false
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once
      end

      it 'has a working method_missing method' do
        expect{ @time.hellobrah }.to raise_exception NoMethodError
        expect(@time.timezone).to eq 'EDT'
        expect(a_request(:get, 'https://api.uwaterloo.ca/v2/server/time.json?format=json&key=testkey')).to have_been_made.once        
      end

      it 'allows retrieval of metadata' do
        expect{ @time.meta(:status) }.to raise_exception RuntimeError
        @time.get
        expect(@time.meta(:status)).to eq 200
        expect(@time.meta(:method_id)).to eq 1087
      end

      it 'can detect invalid method chains' do
        expect{ @api.terms.get }.to raise_exception NoMethodError
        expect{ @api.terms.term(1139).meta :status }.to raise_exception NoMethodError
        expect{ @api.courses.catalog_number(1) }.to raise_exception NoMethodError
        expect{ @api.foodservices.year(2013).announcements }.to raise_exception NoMethodError
      end
    end
  end
end
