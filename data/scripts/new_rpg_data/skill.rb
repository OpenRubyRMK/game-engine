require_relative "baseitem"
require_relative "usableitem"
module RPG
	class Skill < BaseItem
		include UsableItem
	end
end
module Game
	class Skill < BaseItem
		include UsableItem	
	end
end
