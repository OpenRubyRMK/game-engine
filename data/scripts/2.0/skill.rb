require_relative "base_item"
require_relative "usable_item"

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