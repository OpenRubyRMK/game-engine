require_relative "battler"
require_relative "rpgclasses"
require_relative "gameclasses"
require_relative "translation"

module RPG
	class Enemy
		include RPG::RPGClasses
		attr_accessor :baseAtk,:baseSpi,:baseDef,:baseAgi
		
		translation :name
		def initialize()
			@baseAtk=0
			@baseSpi=0
			@baseDef=0
			@baseAgi=0
			cs_init
			Enemy.instances.push(self)
		end
		
	end
end
module Game
	class Enemy < Battler
		include Game::GameClasses

		def baseAtk
			return data.baseAtk
		end
		def baseSpi
			return data.baseSpi
		end
		def baseDef
			return data.baseDef
		end
		def baseAgi
			return data.baseAgi
		end
	end
end