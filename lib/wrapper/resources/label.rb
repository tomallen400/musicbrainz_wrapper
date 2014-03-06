class Musicbrainz::Label
	
	attr_accessor :id, :name, :sort_name, :country, :disambiguation, :ipis, :type, :score, :label_code, :country, :area, :life_span, :tags
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.area = Musicbrainz::Area.new(self.area) if self.area
		self.life_span = Musicbrainz::Area.new(self.life_span) if self.life_span
		self.tags_initialize if self.tags
	end
	
	def tags_initialize
		array = []
		self.tags.each do |a|
			array << Musicbrainz::Tag.new(a)
		end
		self.tags = array
	end
	
end