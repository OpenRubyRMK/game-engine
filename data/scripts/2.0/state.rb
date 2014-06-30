require_relative "base_item"

module RPG
  class State < BaseItem

    #translation :name
    attr_accessor :stocks
    def initialize(name)
      super
      @states_cancel = []
      @states_chance = Hash.new(1.0)
      @stocks=0
    end

    def parse_xml(state)
      super
      @stocks = state[:stocks].to_i
    end
  end
end

module Game
  class State < BaseObject
    
    def rpg
      return RPG::State[@name]
    end
  end
end
