require_relative "battlerskills"
require_relative "battlerstate"

module RPG
	class Skill
		attr_proxy :passive_states
		private
		def passivestates_cs_init#:nodoc:
			@passive_states = Proxy.new([],RPG::State)
		end
	end
end
module Game
	class Skill
		attr_reader :passive_states
		private
		def passivestates_cs_init#:nodoc:
			@passive_states = Proxy.new({},RPG::State,Game::State)
			self.data.passive_states.each {|state| @passive_states[state]=State.new(state)}
		end
	end
	class Battler
		def passivestates_cs_states#:nodoc:
			result =Hash.new([])
			skills.values.flatten.each {|skill| skill.passive_states.each {|rstate,gstate| result[rstate]+=[gstate] }}
			return result
		end
	end
end