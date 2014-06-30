require_relative "base_item"
require_relative "levelable"

module RPG
  class Mastery < BaseItem
    include Levelable
  end
end

module Game
  class Mastery < BaseObject
    include Levelable

    attr_reader :battler
    attr_accessor :baselevel
    def initialize(name,battler)
      super(name)
      @battler = battler
      @baselevel = 0
    end

    def rpg
      return RPG::Mastery[@name]
    end

    def _level
      return []
    end

    def level
      return _level.inject(@baselevel,:+)
    end

    def levelup(l = 1)
      @baselevel += l
      #cs_levelup
      return self
    end
  end
end
