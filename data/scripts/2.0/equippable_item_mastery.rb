require_relative "battler_equip"
require_relative "battler_mastery"

module RPG
  module EquippableItem
    attr_accessor :required_masteries,:level_masteries

    chain "EquipMasteryInfluence" do
      def _init_equippable
        super
        @required_masteries = Hash.new(0)
        @level_masteries = Hash.new(0)
      end

      def _to_xml_equippable(xml)
        super
        xml.required_masteries {
          @required_masteries.each{|k,l| xml.mastery(:name=>k,:level=>l) }
        }
        xml.level_masteries {
          @level_masteries.each{|k,l| xml.mastery(:name=>k,:value=>l) }
        }
      end

      def _parse_xml_equippable(item)
        super
        item.xpath("required_masteries/mastery").each {|node|
          @required_masteries[node[:name].to_sym]=node[:level].to_i
          Mastery.parse_xml(node) unless node.children.empty?
        }
        item.xpath("level_masteries/mastery").each {|node|
          @level_masteries[node[:name].to_sym]=node[:value].to_i
          Mastery.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Mastery
    chain "EquipMasteryInfluence" do
      def _level
        super + @battler.equips.map {|k,e| e.rpg.level_masteries[@name]}
      end
    end
  end
end