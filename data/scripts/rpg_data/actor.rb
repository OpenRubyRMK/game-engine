require_relative "battler"
require_relative "rpgclasses"
require_relative "gameclasses"
require_relative "levelble"
module RPG
	class Actor
		include RPG::RPGClasses
		include RPG::Levelble
		
		translation :name
		
		def initialize
			cs_init
			Actor.instances.push(self)
			@exp_basis =25
			@exp_inflation = 35
			self.max_level=100
		end
		
		def max_level=(value)
			@max_level = value
			cs_set_max_level(value){|hash| hash.delete_if{|k,v| k >=value}}
			return value
		end
	end
end

module Game
	class Actor < Battler
		include Game::GameClasses
		include Game::Levelble
		def initialize(battler)
			super(battler)
		end
	end
end