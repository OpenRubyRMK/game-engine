require_relative "battlerstate"
require_relative "battlerability"
module RPG
	class Ability
		attr_proxy :def_states_multi,:def_states_add
		private
		def def_states_cs_init#:nodoc:
			@def_states_multi = Proxy.new(Hash.new(1),State,Float)
			@def_states_add = Proxy.new(Hash.new(0),State,Float) 
		end
	end
end
module Game
	class Battler
		private
		def ability_cs_states_multi(state)#:nodoc:
			temp = 1
			self.abilities.each_values {|gab| temp *= gab.data.def_states_multi[state]}
			return temp
		end
		def ability_cs_states_add(state)#:nodoc:
			temp = 0
			self.abilities.each_values {|gab| temp += gab.data.def_states_multi[state]}
			return temp
		end
	end
end
