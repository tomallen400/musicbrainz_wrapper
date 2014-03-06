class Musicbrainz::LabelInfo
	
	attr_accessor :catalog_number, :label
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.label = Musicbrainz::Label.new(self.label) if self.label
	end
	
end