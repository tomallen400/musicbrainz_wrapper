class Musicbrainz::TextRepresentation
	
	attr_accessor :language, :script
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end