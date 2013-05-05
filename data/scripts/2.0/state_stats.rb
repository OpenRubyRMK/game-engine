require_relative "battler_state"

module RPG
  class State
    attr_accessor :stats

    chain "StateStatsInfluence" do
      def initialize(*)
        super
        @stats = Hash.new(1.0)
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
end

module Game
  class Battler
    chain "StateStatsInfluence" do
      def _stat_multi(key)
        super + _states(nil).map {|state| state.rpg.stats[key]}
      end
    end
  end
end