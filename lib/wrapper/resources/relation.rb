class Musicbrainz::Relation
	
	attr_accessor :type, :type_id, :direction, :artist, :end, :ended, :begin, :attributes, :work, :recording
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.child_initializers
	end
	
	def child_initializers
		self.recording = Musicbrainz::Recording.new(self.recording) if self.recording
		self.artist = Musicbrainz::Artist.new(self.artist) if self.artist
		self.work = Musicbrainz::Work.new(self.work) if self.work
	end
	
end