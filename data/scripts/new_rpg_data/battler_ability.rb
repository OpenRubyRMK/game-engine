require_relative "battler"
require_relative "ability"

module Game
	class Battler
		attr_reader :abilities
		def add_ability(k)
			temp = Ability.new(k,self)
			@abilities[k] = temp
			cs_add_abilitiy(k)
			return temp
		end
		private
		def abilities_cs_init
			@abilities = {}
		end
	end
end

