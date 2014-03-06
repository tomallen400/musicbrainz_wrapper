class Musicbrainz::LifeSpan
	
	attr_accessor :begin, :end, :ended
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end