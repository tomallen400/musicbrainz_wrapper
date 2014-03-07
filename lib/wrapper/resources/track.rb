class Musicbrainz::Track
	
	attr_accessor :length, :number, :recording
	
	def initialize args
		args.each do |k, v|
  		instance_variable_set("@#{k.gsub('-', '_')}", v) unless v.nil?
  	end
  	self.recording = Musicbrainz::Recording.new(self.recording) if self.recording
	end
	
end