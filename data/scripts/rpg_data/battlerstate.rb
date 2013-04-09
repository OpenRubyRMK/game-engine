require "statestats"
require "proxy"
require "battler"
class Game::Battler
	#attr_reader :states

	def states
		result =Hash.new([])
		cs_states.each {|hash| hash.each {|rstat,gstats| result[rstat]+= gstats }}
		return result
	end
	
	def add_state(rpg_state)
		rpg_state.states_cancel.each {|s| remove_state(s)}
		@states[rpg_state].max_size = rpg_state.stocks + 1
		@states[rpg_state] += [Game::State.new(rpg_state)]
		cs_add_state(rpg_state)
	end
	
	def remove_state(state)
		cs_remove_state(state)
		case state
		when RPG::State
			@states.delete(state)
		when Game::State
			@states[state.data].delete(state)
			remove_state(state.data) if @states[state.data].empty?
		end
	end
	
	private
	#CS includes
	def states_cs_init
		@states = Proxy.new({},RPG::State,Proxy.new([],Game::State))
	end
	def states_cs_states
		hash = Hash.new([])
		@states.each {|s,pr| hash[s] += pr }
		return hash
	end
	def states_cs_stat_multi(stat)
		temp = 1
		states.values.flatten.each {|s| temp *= s.send("#{stat}_rate") if s.respond_to?("#{stat}_rate")}
		return temp
	end
	
	def states_cs_update_turn
		@states.each { |key,array| array.each { |s|
				case s.turns <=> 0
				when 1
					s.turns -=1
				when 0
					remove_stat(s) if rand() < s.auto_release_prob
				end
			} }
	end
end   