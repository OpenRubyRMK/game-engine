require_relative "levelable_feature"
require_relative "feature_skill"

module Game
	module Levelable
		class Level
			def skills(key=nil)
				return _list_group_by(_featureable_skills(key), key)
			end
		end
	end
end
