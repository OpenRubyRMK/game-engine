require_relative "equippable_item"

module RPG
  class Weapon < BaseItem
    include EquippableItem
  end
end

module Game
  class Weapon < BaseItem
	  def rpg
      return RPG::Weapon[@name]
    end
    include EquippableItem
  end
end
