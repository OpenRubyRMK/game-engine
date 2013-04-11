require_relative "base_object"
module RPG
  class State < BaseObject

    #translation :name
    attr_accessor :states_cancel
    attr_accessor :states_chance
    attr_accessor :stocks
    def initialize(name)
      super
      @states_cancel = []
      @states_chance = Hash.new(1.0)
      @stocks=0
    end
    
    def _to_xml(xml)
      #xml.state(:name => @name,:stocks=>@stocks) { 
      xml.cancel { @states_cancel.each {|s| xml.state(:name=>s) }}
      xml.chance { @states_chance.each {|s,v| xml.state(v,:name=>s) }}
    end

    def parse_xml(state)
      @stocks = state[:stocks].to_i
      state.xpath("cancel/state").each {|node|
        @states_cancel << node[:name].to_sym
      }
      state.xpath("chance/state").each {|node|
        @states_chance[node[:name].to_sym] = node.text.to_f
      }
    end
  end
end

module Game
  class State
    attr_reader :name
    def initialize(name)
      @name = name
    end
    def rpg
      return RPG::State[@name]
    end
    
    def states_chance
      return rpg.states_chance
    end
  end
end
