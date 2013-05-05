require_relative "battler_equip"
require_relative "battler_mastery"

module RPG
  module EquippableItem
    attr_accessor :required_masteries,:level_masteries,:mastery_rate

    chain "EquipMasteryInfluence" do
      def _init_equippable
        super
        @required_masteries = Hash.new(0)
        @level_masteries = Hash.new(0)
        @mastery_rate = Hash.new(1.0)
      end

      def _to_xml_equippable(xml)
        super
        xml.required_masteries {
          @required_masteries.each{|k,l| xml.mastery(:name=>k,:level=>l) }
        }
        xml.level_masteries {
          @level_masteries.each{|k,l| xml.mastery(:name=>k,:value=>l) }
        }
        xml.mastery_rate{
          @mastery_rate.each{|k,v| xml.mastery(v,:name=>k) }
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
        item.xpath("mastery_rate/mastery").each {|node|
          @mastery_rate[node[:name].to_sym] = node.text.to_f
        }
      end
    end
  end
end

module Game
  class Battler
    chain "EquipMasteryInfluence" do
      def _mastery_rate(k)
        super + equips.map {|_,item| k ? item.rpg.mastery_rate[k] : item.rpg.mastery_rate }
      end

      def _can_equip(key,item)
        super + [RPG::BaseItem[item].required_masteries.all? {|k,l| mastery[k] && mastery[k].level >= l }]
      end
    end
  end

  class Mastery
    chain "EquipMasteryInfluence" do
      def _level
        super + @battler.equips.map {|k,e| e.rpg.level_masteries[@name]}
      end
    end
  end
end