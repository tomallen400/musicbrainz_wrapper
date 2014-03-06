class Musicbrainz::Media
	
	attr_accessor :format, :disc_count, :track_count
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end