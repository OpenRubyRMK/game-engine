require 'actor'
require 'unit'

module RPG
	class Party
		include RPGClasses
		attr_proxy :members
		def initialize
			@members = Proxy.new([],Actor)
			cs_init
			Party.instances.push(self)
		end
	end
end

module Game
	class Party < Unit
		include GameClasses
		def initialize(party)
			self.data=party
			super()
			self.members= self.data.members.map {|e| Actor.new(e)}
		end
		def max_level
			actor = self.members.max {|a,b| a.level <=> b.level}
			return actor.nil? ? 0 : actor.level
		end
	end
end