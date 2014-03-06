class Musicbrainz::ReleaseEvent
	
	attr_accessor :area, :date
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.area = Musicbrainz::Area.new(self.area) if self.area
	end
	
end