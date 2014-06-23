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
      def parse_xml(xml)
      end
      def _to_xml(xml)
      end
      
      def to_xml(xml)
        xml.level(:level => @level) { _to_xml(xml) }
      end
      
      def self.parse_xml(xml)
        temp = new(xml[:level].to_i)
        temp.parse_xml(xml)
        return temp
      end
    end
    
    def parse_xml(xml)
      super
      xml.xpath("levelable/level").each {|node|
        @levels[node[:level].to_i] = Level.parse_xml(node)
      }
    end
    
    def _to_xml(xml)
      super
      xml.levelable {
        @levels.each_value {|level|
          level.to_xml(xml)
        }
      }
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
