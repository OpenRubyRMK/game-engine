require_relative "battler"
require_relative "state"
module Game
	class Battler
		
		def states
			result = Hash.new([])
			cs_states {|o| o.each{|k,v| result[k] += v }}
			#result.each{|k,v|
			#if v.size > RPG::State[k].stocks
			return result
		end
		def states_chance
			result = Hash.new(1.0)
			cs_states_chance {|o| o.each{|k,v| result[k] *= v }}
			return result
		end
		def add_state(k)
			temp = State.new(k)
			if(@states[k].size > temp.rpg.stocks)
				@states[k].shift
			end
			#states_cancel
			temp.rpg.states_cancel.each {|c|	@states[c].each{remove_state(c)} }
			@states[k] += [temp]
			cs_add_state(k)
			return temp
		end
		
		def remove_state(k)
			unless(@states[k].empty?)
				temp = @states[k].shift
				cs_remove_state(k)
				return temp
			else
				return nil
			end
		end
		
		private
		def states_cs_init
			@states = Hash.new([])
		end
		
		def states_cs_states
			return @states
		end
		
		def states_cs_states_chance
			result = Hash.new(1.0)
			states.each{|k,o| o.each {
					RPG::State[k].states_chance.each{|f,n|	result[f] *= n }
			}	}
			return result
		end
		
		def dead_state
			raise NotImplementedError
		end
		
		def dead_cs_stat_change(stat,old)
			if stat == :hp && old != @hp
				if @hp == 0
					add_state(dead_state)
				else
					remove_state(dead_state)
				end
			end
		end
	end
end
