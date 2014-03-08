class Musicbrainz::Area
	
	attr_accessor :id, :name, :sort_name, :disambiguation, :iso_3166_3_codes, :iso_3166_2_codes, :iso_3166_1_codes, :begin, :end, :ended
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end