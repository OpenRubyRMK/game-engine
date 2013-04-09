require_relative "./battlerstate"
require_relative "./actorjp"
#[cat]   small domestic animal
#[+cat+] command to copy standard input
module RPG
	class State
		attr_accessor :jp_cost,:jp_rate
		attr_proxy :jp_require_actorclass,:jp_require_states

		private
		def jp_cs_init#:nodoc:
			@jp_cost = 0
			@jp_rate = 1
			@jp_require_actorclass = Proxy.new(Hash.new(0),RPG::ActorClass,Integer)
			@jp_require_states = Proxy.new([],RPG::State)
		end
	end
end
module Game
	class Battler
		private
#--
		def statejp_cs_init#:nodoc:
			@jpstates = Proxy.new({},RPG::State,Game::State)
		end
		def statejp_cs_earn_jp_multi#:nodoc:
			result = 1
			self.states.values.flatten.each {|state| result *= state.data.jp_rate}
			return result
		end
		def statejp_cs_jp_can_learn(obj)#:nodoc:
			return true unless obj.respond_to?(:jp_require_states)
			return obj.jp_require_states.all? {|state| self.states.include?(state)}
		end
		def statejp_cs_jp_learn(state)#:nodoc:
			return unless state.is_a?(RPG::State)
			@jpstates[state] = Game::State.new(state)
		end
		def statejp_cs_states#:nodoc:
			result = Hash.new([])
			@jpstates.each{|rskill,gskill| result[rskill] = [gskill]}
			return result
		end
#++
	end
end