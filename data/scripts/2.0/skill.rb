require_relative "usable_item"

module RPG
  class Skill < BaseItem
    include UsableItem
    def initialize(*)
      super
      @max_uses = nil
    end
  end
end

module Game
  class Skill < BaseItem
    include UsableItem
    
    
    def rpg
      return RPG::Skill[@name]
    end
  end
end
