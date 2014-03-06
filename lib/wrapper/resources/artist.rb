class Musicbrainz::Artist
	
	attr_accessor :id, :name, :sort_name, :disambiguation, :ipis, :type, :country, :area, :begin_area, :life_span, :aliases, :tags
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.area = Musicbrainz::Area.new(self.area) if self.area
		self.begin_area = Musicbrainz::Area.new(self.begin_area) if self.begin_area
		self.life_span = Musicbrainz::Area.new(self.life_span) if self.life_span
		self.aliases_initialize if self.aliases
		self.tags_initialize if self.tags
	end
	
	def aliases_initialize
		array = []
		self.aliases.each do |a|
			array << Musicbrainz::Alias.new(a)
		end
		self.aliases = array
	end
	
	def tags_initialize
		array = []
		self.tags.each do |a|
			array << Musicbrainz::Tag.new(a)
		end
		self.tags = array
	end
	
end