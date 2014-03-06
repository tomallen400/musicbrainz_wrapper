class Musicbrainz::ReleaseGroup
	
	attr_accessor :id, :title, :count, :score, :primary_type, :secondary_types, :artist_credit, :disambiguation, :first_release_date, :releases, :tags
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.artists_initialize if self.artist_credit
		self.releases_initialize if self.releases
		self.tags_initialize if self.tags
	end
	
	def artists_initialize
		array = []
		self.artist_credit.each do |a|
			array << Musicbrainz::Artist.new(a["artist"]) if a["artist"]
		end
		self.artist_credit = array
	end
	
	def releases_initialize
		array = []
		self.releases.each do |a|
			array << Musicbrainz::Release.new(a)
		end
		self.releases = array
	end
	
	def tags_initialize
		array = []
		self.tags.each do |a|
			array << Musicbrainz::Tag.new(a)
		end
		self.tags = array
	end
	
end