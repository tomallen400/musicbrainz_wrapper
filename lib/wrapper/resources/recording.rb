class Musicbrainz::Recording
	
	attr_accessor :id, :title, :disambiguation, :score, :length, :video, :artist_credit, :releases, :tags, :relations, :recording, :work
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.recording = Musicbrainz::Recording.new(self.recording) if self.recording
		self.work = Musicbrainz::Work.new(self.work) if self.work
		self.artists_initialize if self.artist_credit
		self.tags_initialize if self.tags
		self.releases_initialize if self.releases
		self.relations_initialize if self.relations
	end
	
	def artists_initialize
		array = []
		self.artist_credit.each do |a|
			array << Musicbrainz::Artist.new(a["artist"]) if a["artist"]
		end
		self.artist_credit = array
	end
	
	def tags_initialize
		array = []
		self.tags.each do |a|
			array << Musicbrainz::Tag.new(a)
		end
		self.tags = array
	end
	
	def releases_initialize
		array = []
		self.releases.each do |a|
			array << Musicbrainz::Release.new(a)
		end
		self.releases = array
	end
	
	def relations_initialize
		array = []
		self.relations.each do |a|
			array << Musicbrainz::Relation.new(a)
		end
		self.relations = array
	end
	
end