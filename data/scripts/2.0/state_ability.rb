require_relative "battler_state"
require_relative "battler_ability"

module RPG
  class State
    attr_accessor :level_abilities

    chain "StateAbilityInfluence" do
      def initialize(*)
        super
        @level_abilities = Hash.new(0)
      end

      def _to_xml(xml)
        super
        xml.level_abilities {
          @level_abilities.each{|k,l| xml.ability(:name=>k,:value=>l) }
        }

      end

      def _parse_xml(item)
        super
        item.xpath("level_abilities/ability").each {|node|
          @level_abilities[node[:name].to_sym]=node[:value].to_i
          Ability.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Ability
    chain "StateAbilityInfluence" do
      def _level
        super + @battler._states(nil).map {|st| st.rpg.level_abilities[@name]}
      end
    end
  end
end