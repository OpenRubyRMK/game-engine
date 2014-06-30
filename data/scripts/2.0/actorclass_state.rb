require_relative "actorclass"
require_relative "levelable_state"



module Game
	class ActorClass
		def states_chance(key = nil)
			return _list_combine(_featureable_states_chance(key), key, 1.0, :*)
		end
		
		def states(key = nil)
			return _list_group_by(_featureable_states(key), key)
		end
		
		def suspended_states
			return _featureable_suspend_states
		end
		
		def available_states_chance(key = nil)
			return _list_combine(_featureable_states_chance(key, @battler), key, 1.0, :*)
		end
		
		def available_states(key = nil)
			return _list_group_by(_featureable_states(key, @battler), key)
		end
		
		def available_suspended_states
			return _featureable_suspend_states(@battler)
		end
	end
end
