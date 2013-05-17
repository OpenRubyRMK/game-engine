require_relative "battler_equip"
require_relative "battler_ability"
require_relative "requirement_ability"

module RPG
  module EquippableItem
    attr_accessor :required_abilities,:level_abilities

    chain "EquipAbilityInfluence" do
      def _init_equippable
        super
        @level_abilities = Hash.new(0)
      end

      def _to_xml_equippable(xml)
        super
        xml.level_abilities {
          @level_abilities.each{|k,l| xml.ability(:name=>k,:value=>l) }
        }
      end

      def _parse_xml_equippable(item)
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
    chain "EquipAbilityInfluence" do
      def _level
        super + @battler.equips.map {|k,e| e.rpg.level_abilities[@name]}
      end
    end
  end
end