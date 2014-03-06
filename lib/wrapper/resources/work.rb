class Musicbrainz::Work
	
	attr_accessor :id, :title, :type, :score, :language, :relations, :iswcs, :disambiguation
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.relations_initialize if self.relations
	end
	
	def relations_initialize
		array = []
		self.relations.each do |a|
			array << Musicbrainz::Relation.new(a)
		end
		self.relations = array
	end
	
end