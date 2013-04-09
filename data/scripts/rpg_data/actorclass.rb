require_relative "csmod"
require_relative "rpgclasses"
require_relative "gameclasses"
module RPG
	class ActorClass
		include RPG::RPGClasses
		
		translation :name
		def initialize
			cs_init
			ActorClass.instances.push(self)
		end
		def icon
		end
	end
end
module Game
	class ActorClass
		include Game::GameClasses
		attr_reader :level
		attr_accessor :max_level
		def initialize(value)
			self.data=value
			@level=0
			cs_init
		end
		def name
			self.data.name
		end
		def upgrade
			if @max_level.nil? || @level < @max_level
				@level+=1
				cs_levelup
			end
		end
	end
end