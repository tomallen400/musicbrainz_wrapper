class Musicbrainz::CoverArtArchive
	
	attr_accessor :count, :front, :artwork, :back, :darkened
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end