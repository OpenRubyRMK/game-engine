require_relative "chain_module"


module RPG
  module Levelable
    attr_accessor :levels
    
    def initialize(*)
      super
      @levels = {}
    end
    
    def add_level(l)
      lev = Level.new(l)
      yield lev if block_given?
      @levels[l] = lev
    end
    
    class Level
      attr_accessor :level
      def initialize(l)
        @level = l
      end
    end
  end
  
end

module Game
  module Levelable
    def initialize(*)
      super
      @levels = Hash[rpg.levels.map {|k,v| [k,Level.new(v)]}]
    end
        
    class Level
      def initialize(rpg)
        
      end
    end
  end
end