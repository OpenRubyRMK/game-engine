require_relative "base_object"
require_relative "levelable"


module RPG
  class Ability < BaseObject
    include Levelable
  end
end

module Game
  class Ability
    prepend Levelable
    
    attr_reader :name,:battler
    attr_accessor :baselevel
    def initialize(name,battler)
      #super
      @name = name
      @battler = battler
      @baselevel = 0
    end
    def rpg
      return RPG::Ability[@name]
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
