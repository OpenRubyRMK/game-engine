require_relative "base_item"
require_relative "equipable_item"
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