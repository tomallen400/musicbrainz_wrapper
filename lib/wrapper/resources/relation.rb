class Musicbrainz::Relation
	
	attr_accessor :type, :direction, :artist
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.artist = Musicbrainz::Artist.new(self.artist) if self.artist
	end
	
end