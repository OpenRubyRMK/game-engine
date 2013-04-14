require_relative "base_item"

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
    attr_reader :equip_stats
    def self.extended(obj)
      super
      obj._init_equippable
    end

    def _init_equippable
      @equip_stats=Hash.new(0)
    end

    def initialize(*)
      super
      _init_equippable
    end

    def _to_xml(xml)
      super
      xml.equippable{
        xml.stats{
          @equip_stats.each{|name,v|
            xml.stat(v,:name=>name)
          }
          _to_xml_equippable_stats(xml)
        }
        _to_xml_equippable(xml)
      }
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
