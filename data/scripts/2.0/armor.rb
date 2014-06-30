require_relative "equippable_item"

module RPG
  class Armor < BaseItem
    include EquippableItem
  end
end

module Game
  class Armor < BaseItem
    include EquippableItem
  end
end
