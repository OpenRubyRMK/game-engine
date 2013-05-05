require_relative "enemy"
require_relative "battler_ability"

module RPG
  class Enemy
    attr_accessor :abilities
    private
    chain "AbilityInfluence" do
      def initialize(*)
        super
        @abilities = {}
      end

      def _to_xml(xml)
        super
        xml.abilities{
          @abilities.each{|k,l| xml.ability(:name=>k,:level=>l) }
        }

      end

      def _parse_xml(enemy)
        super
        enemy.xpath("abilities/ability").each {|node|
          @abilities[node[:name].to_sym] = node[:level].to_i
        }
      end
    end
  end
end

module Game
  class Enemy
    chain "AbilityInfluence" do
      def initialize(*)
        super
        rpg.abilities.each {|k,l| add_ability(k).levelup(l)}
      end
    end
  end
end
