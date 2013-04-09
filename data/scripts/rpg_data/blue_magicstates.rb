require "blue_magic"
require "battlerstate"

module RPG
	class Ability
		attr_proxy :blue_magic_states
		private
		def blue_magic_states_cs_init
			@blue_magic_states =Proxy.new(Hash.new(1),State,Float)
		end
	end
end
module Game
	class Battler
		private
		def states_cs_blue_magic_multi(skill,atri)
			result = 1
			self.states.values.flatten.each { |gstate| result *= atri.data.blue_magic_states[gstate.data] }
			return result
		end
	end
end