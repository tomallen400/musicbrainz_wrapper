class Musicbrainz::Media
	
	attr_accessor :format, :disc_count, :track_count, :tracks
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.tracks_initialize if self.tracks
	end
	
	def tracks_initialize
		array = []
		self.tracks.each do |a|
			array << Musicbrainz::Track.new(a)
		end
		self.tracks = array
	end
	
end