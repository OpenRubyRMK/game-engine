require_relative "battler"
require_relative "state"
require_relative "chain_module"

module Game
  class Battler

    chain "StatsInfluence" do
      def initialize(*)
        super
        @states = Hash.new([])
      end

      def hp=(value)
        super
        @hp > 0 ? remove_state(dead_state) : add_state(dead_state)
        return value
      end

    end

    def _suspended_states
      []
    end
    
    def suspended_states
      _suspended_states.uniq
    end

    def state_suspended?(key)
      suspended_states.include?(key)
    end

    def states(key=nil)
      #if _stack[:states]
      #  _stack[:states] = false
      #  return key ? [] : {}
      #end
      return [] if key && state_suspended?(key)
      
      #_stack[:states] = true
      list = _states(key)
      return key ? list : list.group_by(&:name).select {|k,_| !state_suspended?(k) }
    end

    def states_chance(key=nil)
      return _list_combine(_states_chance(key), key, 1.0, :*)
    end

    def add_state(k)
      return notify_observers(:added_state) {
        temp = State.new(k)
        if(@states[k].size > temp.rpg.stocks)
          remove_state(k)
        end
				
				#states_cancel
				if temp.respond_to?(:states_cancel)
					temp.states_cancel.each {|c|  @states[c].each{remove_state(c)} }
				end
				
				@states[k] += [temp]

        temp
      }
    end

    def remove_state(k)
      unless(@states[k].empty?)
        return notify_observers(:removed_state) { @states[k].shift }
      else
        return nil
      end
    end

    def _states(key = nil)
      return key ? @states[key] : (@states || {}).values.flatten
    end

		def _states_chance(key)
			[]
		end

    def dead_state
      raise NotImplementedError
    end
    
    def alive?
      return states(dead_state).empty?
    end
    
    def dead?
      !alive?
    end
  end
end
