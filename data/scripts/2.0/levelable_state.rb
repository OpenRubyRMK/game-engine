require_relative "levelable_feature"
require_relative "feature_state"

module Game
	module Levelable
		class Level
			
			def states_chance(key = nil)
				return _list_combine(_featureable_states_chance(key), key, 1.0, :*)
			end
			
			def states(key = nil)
				return _list_group_by(_featureable_states(key), key)
			end
			
			def suspended_states
				return _featureable_suspend_states
			end
			
		end
	end
end
