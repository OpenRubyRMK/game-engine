require_relative "battler"
require_relative "base_item"
module RPG
  class Actor < BaseItem
    
  end
end
module Game
  class Actor < Battler
    def rpg
      return RPG::Actor[@name]
    end
    def basehp
      return 0#rpg.stats[:hp]
    end
    def basemp
      return 0#rpg.stats[:mp]
    end
  end
end
