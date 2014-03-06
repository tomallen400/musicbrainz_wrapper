require 'spec_helper'

describe Musicbrainz::Wrapper do
	
	let(:wrapper) { Musicbrainz::Wrapper.new(:username => 'username', :password => 'password') }
	let(:api_point) { 'http://musicbrainz.org/ws/2/' }
	let(:album_query) { 'release/d883e644-5ec0-4928-9ccd-fc78bc306a46?fmt=json' }
	let(:albums_query) { 'release/?query=artist:The%20Rolling%20Stones&fmt=json' }
	subject { wrapper }
	
	it { should respond_to(:username) }
	it { should respond_to(:password) }
	
	# Query String
	describe "create_query_string" do
		subject { Musicbrainz::Wrapper.create_query_string('release', {:artist => "The Rolling Stones", :release => "Sticky Fingers", :inc => {:isrcs => true, :artist_rels => true}}) }
		it { should be_an_instance_of String }
		it { should include('artist:The%20Rolling%20Stones+release:Sticky%20Fingers') }
		it "should add id to string preceded by a / if id supplied" do
			Musicbrainz::Wrapper.create_query_string('release', {:id => "id", :inc => {:isrcs => true, :artist_rels => true}}).should include('/id')
		end
		it "should add each of the passed queries preceded by ?query= and separate with +s" do
			should include('?query=artist:The%20Rolling%20Stones+release:Sticky%20Fingers')
		end
		it "should add all incs" do
			should include('&inc=isrcs+artist-rels')
		end
		it "should add &fmt=json to end of string" do
			should include('&fmt=json')
		end
		it "should return the start if passed blank hash" do
			Musicbrainz::Wrapper.create_query_string('release', {}).should == 'release/'
		end
		it "should return the start if not passed hash" do
			Musicbrainz::Wrapper.create_query_string('release', nil).should == 'release/'
		end
	end
	
	describe "hash_to_query_string" do
		it "should return a string" do
			Musicbrainz::Wrapper.hash_to_query_string(:id => "123456").should be_an_instance_of String
		end
		it "should return id if id supplied" do
			Musicbrainz::Wrapper.hash_to_query_string(:id => "123456").should == "123456"
		end
		it "should return ?query=queries if no id" do
			Musicbrainz::Wrapper.hash_to_query_string(:artist => "The Rolling Stones", :release => "Sticky Fingers").should == "?query=artist:The%20Rolling%20Stones+release:Sticky%20Fingers"
		end
	end
	
	describe "query_array" do
		subject { Musicbrainz::Wrapper.query_array(:artist => "Stones", :release => "Sticky Fingers", :inc => {:isrcs => true, :artist_rels => true}) }
		it { should be_an_instance_of Array }
		it { subject.first.should be_an_instance_of String }
		it { should have(2).Strings }
		it { should include('artist:Stones') }
		it { should include('release:Sticky%20Fingers') }
	end
	
	describe "append_inc" do
		subject { Musicbrainz::Wrapper.append_inc('string', {:artist => "The Rolling Stones", :release => "Sticky Fingers", :inc => {:isrcs => true, :artist_rels => true}}) }
		it { should be_an_instance_of String }
		context "when inc exists" do
			it { should include('?inc=') }
			it "should include &inc= if string does contain ?" do
				Musicbrainz::Wrapper.append_inc('?string', {:artist => "The Rolling Stones", :release => "Sticky Fingers", :inc => {:isrcs => true, :artist_rels => true}}).should include('&inc=')
			end
			it { should include('inc=isrcs+artist-rels') }
		end
		context "when inc doesn't exist" do
			it "should return the original string if inc does not exist" do
				Musicbrainz::Wrapper.append_inc('string', {:artist => "The Rolling Stones", :release => "Sticky Fingers"}).should == 'string'
			end
		end
	end
	
	describe "inc_values_array" do
		subject { Musicbrainz::Wrapper.inc_values_array(:isrcs => true, :artist_rels => true, :something_else => false) }
		it { should be_an_instance_of Array }
		it { subject.first.should be_an_instance_of String }
		it "should have a value for each that has true" do
			should have(2).Strings
		end
		it "should replace all _ with -" do
			should include('artist-rels')
		end
	end
	
	describe "question_mark_or_ampersand" do
		it "should return a string" do
			Musicbrainz::Wrapper.question_mark_or_ampersand("string").should be_an_instance_of String
		end
		it "should return a ? if one is not already in string" do
			Musicbrainz::Wrapper.question_mark_or_ampersand("string").should == '?'
		end
		it "should return a & if a ? is in string" do
			Musicbrainz::Wrapper.question_mark_or_ampersand("string?").should == '&'
		end
	end
	
	# Hit Musicbrainz API
	describe "query", :slow => true do
		context "is passed a plural object" do
			it "should return an array" do
				wrapper.query(albums_query).should be_an_instance_of Array
			end
		end
		context "is passed a single object" do
			it "should return a hash" do
				wrapper.query(album_query).should be_an_instance_of Hash
			end
		end
		context "is passed bad data" do
			it "should return nil" do
				wrapper.query("something_else").should be_nil
			end
		end
	end
	
	describe "send_query", :slow => true do
		context "when sent a good request" do
			it "should return a Net::HTTPOK object" do
				wrapper.send_query(api_point + album_query).should be_an_instance_of Net::HTTPOK
			end
			it "should return a string as the body" do
				wrapper.send_query(api_point + album_query).body.should be_an_instance_of String
			end
		end
		context "when sent a bad request" do
			it "should return a Net::HTTPBadRequest object" do
				wrapper.send_query(api_point + 'release/d8').should be_an_instance_of Net::HTTPBadRequest
			end
		end
		context "when not finding an object" do
			it "should return a Net::HTTPNotFound object" do
				wrapper.send_query(api_point + 'release/d883e644-5ec0-4928-9ccd-fc78bc306a47').should be_an_instance_of Net::HTTPNotFound
			end
		end
	end
	
	describe "parse_response", :slow => true do
		context "when passed a good response" do
			context "for a single object" do
				it "should return a hash" do
					response = wrapper.send_query(api_point + album_query)
					Musicbrainz::Wrapper.parse_response(response).should be_an_instance_of Hash
				end
			end
			context "for multiple objects" do
				it "should return an array" do
					response = wrapper.send_query(api_point + albums_query)
					Musicbrainz::Wrapper.parse_response(response).should be_an_instance_of Array
				end
			end
		end
		context "when passed a bad response" do
			it "should return nil" do
				response = wrapper.send_query(api_point + 'release/d8')
				Musicbrainz::Wrapper.parse_response(response).should be_nil
			end
		end
	end
	
end