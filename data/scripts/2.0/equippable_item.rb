require_relative "base_item"
require_relative "chain_module"

module RPG
  class BaseItem
    chain "EquippableItem" do
      def _parse_xml(item)
        super
        item.xpath("equippable").each {|node|
          extend(EquippableItem)
          _parse_xml_equippable(node)
        }
      end
    end

  end

  module EquippableItem
    attr_reader :equip_stats, :equip_stats_multi

    attr_accessor :equip_type
    def self.extended(obj)
      super
      obj._init_equippable
    end

    def _init_equippable
      @equip_stats=Hash.new(0)
      @equip_stats_multi=Hash.new(1.0)
    end

    def initialize(*)
      super
      _init_equippable
    end

    def _to_xml(xml)
      super
      xml.equippable{ _to_xml_equippable(xml) }
    end

    def _to_xml_equippable_stats(xml)
      xml.stats{ @equip_stats.each{|name,v| xml.stat(v,:name=>name) }}
    end

    def _to_xml_equippable_stats_multi(xml)
      xml.stats_multi{ @equip_stats_multi.each{|name,v| xml.stat(v,:name=>name) }}
    end

    def _to_xml_equippable(xml)
      _to_xml_equippable_stats(xml)
      _to_xml_equippable_stats_multi(xml)
    end

    def _parse_xml_equippable(node)
    end
  end
end

module Game
  module EquippableItem
    def _init_equippable
    end

    def equip_stat(key)
      return stat(key,rpg.equip_stats[key],:equip)
    end

    def equip_stat_multi(key)
      return stat_multi(key,rpg.equip_stats_multi[key],:equip)
    end

    def equip_type
      rpg.equip_type
    end

    def self.extended(obj)
      super
      obj._init_equippable
    end

    def initialize(*)
      super
      _init_equippable
    end

  end
end
