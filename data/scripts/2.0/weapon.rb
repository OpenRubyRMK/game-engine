require_relative "base_item"
require_relative "equippable_item"
module RPG
	class Weapon < BaseItem
		include EquippableItem 
	end
end
module Game
	class Weapon < BaseItem
		include EquippableItem
	end
end