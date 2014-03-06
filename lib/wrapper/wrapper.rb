class Musicbrainz::Wrapper

	require 'net/https'
	require 'uri'
	require 'json'
	
	attr_accessor :username, :password
	
	@@api_url = "http://musicbrainz.org/ws/2/"
	
	Dir[File.join(File.dirname(__FILE__), "resources", "*.rb")].each { |file| require file }
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k}", v) unless v.nil?
  	end
	end
	
	# artist, label, recording, release, release-group, work, area, url, isrc, iswc, discid
	# discids, media, isrcs, artist-credits, various-artists, aliases, annotation, tags, ratings, user-tags, user-ratings
	# artist-rels, label-rels, recording-rels, release-rels, release-group-rels, url-rels, work-rels
	# recording-level-rels, work-level-rels
	
	def artist(params)
		# artist(:id => "id", :inc => {:isrcs => true, :artist-rels => true})
		response = self.query(Musicbrainz::Wrapper.create_query_string('artist', params))
		Musicbrainz::Artist.new(response) if !response.nil?
	end
	
	def artists(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('artist', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::Artist.new(a)
			end
			array
		end
	end
	
	def label(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('label', params))
		Musicbrainz::Label.new(response) if !response.nil?
	end
	
	def labels(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('label', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::Label.new(a)
			end
			array
		end
	end
	
	def recording(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('recording', params))
		Musicbrainz::Recording.new(response) if !response.nil?
	end
	
	def recordings(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('recording', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::Recording.new(a)
			end
			array
		end
	end
	
	def release(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('release', params))
		Musicbrainz::Release.new(response) if !response.nil?
	end
	
	def releases(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('release', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::Release.new(a)
			end
			array
		end
	end
	
	def release_group(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('release-group', params))
		Musicbrainz::ReleaseGroup.new(response) if !response.nil?
	end
	
	def release_groups(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('release-group', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::ReleaseGroup.new(a)
			end
			array
		end
	end
	
	def work(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('work', params))
		Musicbrainz::Work.new(response) if !response.nil?
	end
	
	def works(params)
		response = self.query(Musicbrainz::Wrapper.create_query_string('work', params))
		if !response.nil?
			array = []
			response.each do |a|
				array << Musicbrainz::Work.new(a)
			end
			array
		end
	end
	
	# Query String
		# releases(:artist => "The Rolling Stones", :release => "Sticky Fingers", :inc => {:isrcs => true, :artist-rels => true})
		# release/?query=artist:The%20Rolling%20Stones+release=Sticky%20Fingers&inc=isrcs&fmt=json
		# release(:id => "id", :inc => {:isrcs => true, :artist-rels => true})
		# recording/8d2338a2-4acc-4d99-b2a7-1151f428cab6?inc=isrcs+artist-rels&fmt=json
	def self.create_query_string(start, params)
  	if params.is_a?(Hash) && params.count > 0
			ending = hash_to_query_string(params)
			"#{start}/#{ending}#{question_mark_or_ampersand(ending)}fmt=json"
		else
			"#{start}/"
  	end
  end
  
  def self.hash_to_query_string(hash)
  	if hash[:id]
  		string = hash[:id]
  	else
  		string = '?query='
  		string += query_array(hash).join('+')
  	end
  	append_inc(string, hash)
  end
  
  def self.query_array(hash)
  	array = []
  	hash.each do |k, v|
  		array << "#{k}:#{URI.encode(v, Regexp.new("[^#{URI::PATTERN::UNRESERVED}]"))}" unless k == :inc
  	end
  	array
  end
  
  def self.append_inc(url, hash)
  	if hash[:inc]
  		"#{url}#{question_mark_or_ampersand(url)}inc=#{inc_values_array(hash[:inc]).join('+')}"
  	else
  		url
  	end
  end
  
  def self.inc_values_array(hash)
  	array = []
  	hash.each do |k, v|
  		array << k.to_s.gsub('_', '-') if v == true
  	end
  	array
  end
  
  def self.question_mark_or_ampersand(string)
  	if string.include?('?')
  		'&'
  	else
  		'?'
  	end
  end
	
	# Hit Musicbrainz API
	def query(ending)
  	query = @@api_url + ending
  	response = self.send_query(query)
  	Musicbrainz::Wrapper.parse_response(response)
  end
  
  def send_query(query)
  	sleep 1
  	uri = URI.parse(query)
  	http = Net::HTTP.new(uri.host, uri.port)
		request = Net::HTTP::Get.new(uri.request_uri)
    http.request(request)
  end
  
  def self.parse_response(response)
		if response.is_a?(Net::HTTPOK)
			json = JSON.parse(response.body) rescue {}
			if json["artist"]
				json["artist"]
			elsif json["labels"]
				json["labels"]
			elsif json["recording"]
				json["recording"]
			elsif json["releases"]
				json["releases"]
			elsif json["release-groups"]
				json["release-groups"]
			elsif json["work"]
				json["work"]
			else
				json
			end
  	end
  end

end