require_relative "battler"
require_relative "base_item"
module RPG
  class Enemy < BaseItem
    attr_reader :stats
    attr_reader :exp
    #translation :name
    
    def initialize(*)
      super
      @stats = Hash.new(0)
      @exp = 0
    end
    def _to_xml(xml)
      super
      xml.stats {
        @stats.each{|k,v| xml.stat(v,:name=>k)}
      }
    end
    def parse_xml(enemy)
      super
      enemy.xpath("stats/stat").each {|node|
        @stats[node[:name].to_sym] = node.text.to_i
      }
    end
  end
end
module Game
  class Enemy < Battler
    def rpg
      return RPG::Enemy[@name]
    end
    def basehp
      return rpg.stats[:hp]
    end
    def basemp
      return rpg.stats[:mp]
    end
    def exp
      return stat(:exp,rpg.exp)
    end
  end
end
