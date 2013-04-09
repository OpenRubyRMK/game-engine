require_relative "baseobject"
module RPG
	class Ability < BaseObject

	end
end

module Game
	class Ability
		attr_reader :name,:battler
		attr_accessor :baselevel
		def initialize(name,battler)
			@name = name
			@battler = battler
			@baselevel = 0
			cs_init
		end
		def rpg
			return RPG::Ability[@name]
		end
		
		def level
			return cs_level.inject(@baselevel,:+)
		end
		def levelup
			@baselevel += 1
			cs_levelup
			return self
		end
	end
end
