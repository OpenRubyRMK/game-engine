require_relative "baseitem"
require_relative "equipableitem"
module RPG
	class Weapon < BaseItem
		include EquipableItem 
	end
end
module Game
	class Weapon < BaseItem
		include EquipableItem
	end
end