class Musicbrainz::Alias
	
	attr_accessor :name, :sort_name, :locale, :type, :primary, :begin_date, :end_date
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
	end
	
end