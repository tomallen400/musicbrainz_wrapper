class Musicbrainz::Release
	
	attr_accessor :id, :title, :score, :count, :status, :text_representation, :artist_credit, :release_group, :area, :date, :country, :release_events, :label_info, :barcode, :asin, :track_count, :media, :cover_art_archive, :quality, :relations
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.area = Musicbrainz::Area.new(self.area) if self.area
		self.text_representation = Musicbrainz::TextRepresentation.new(self.text_representation) if self.text_representation
		self.release_group = Musicbrainz::ReleaseGroup.new(self.release_group) if self.release_group
		self.cover_art_archive = Musicbrainz::CoverArtArchive.new(self.cover_art_archive) if self.cover_art_archive
		self.artists_initialize if self.artist_credit
		self.media_initialize if self.media
		self.label_info_initialize if self.label_info
		self.release_events_initialize if self.release_events
		self.relations_initialize if self.relations
	end
	
	def artists_initialize
		array = []
		self.artist_credit.each do |a|
			array << Musicbrainz::Artist.new(a["artist"]) if a["artist"]
		end
		self.artist_credit = array
	end
	
	def media_initialize
		array = []
		self.media.each do |a|
			array << Musicbrainz::Media.new(a)
		end
		self.media = array
	end
	
	def label_info_initialize
		array = []
		self.label_info.each do |a|
			array << Musicbrainz::LabelInfo.new(a)
		end
		self.label_info = array
	end
	
	def release_events_initialize
		array = []
		self.release_events.each do |a|
			array << Musicbrainz::ReleaseEvent.new(a)
		end
		self.release_events = array
	end
	
	def relations_initialize
		array = []
		self.relations.each do |a|
			array << Musicbrainz::Relation.new(a)
		end
		self.relations = array
	end
	
end