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
    
    def states(key=nil)
      return _states(key).group_by(&:name)
    end

    def states_chance(key=nil)
      temp = _states_chance(key)
      if key 
        return temp.inject(1.0,:*)
      else 
        return temp.inject(Hash.new(1.0)) do |element,hash|
          hash.merge(element) {|k,o,n| o * n}
        end 
      end
    end
    
    def add_state(k)
			return notify_observers(:added_state) {
        temp = State.new(k)
        if(@states[k].size > temp.rpg.stocks)
        	remove_state(k)
        end
        #states_cancel
        temp.rpg.states_cancel.each {|c|  @states[c].each{remove_state(c)} }
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
    
    def _states_chance(key=nil)
      return _states(nil).map { |s| key ? s.states_chance[key] : s.states_chance }
    end
    
    def dead_state
      raise NotImplementedError
    end
    
  end
end
