require_relative "base_item"

module RPG
  class BaseItem
    chain "EquipableItem" do
      def _parse_xml(item)
        super
        item.xpath("equipable").each {|node|
          extend(EquipableItem)
          _parse_xml_equipable(node)
        }
      end
    end

  end

  module EquipableItem
    attr_reader :equip_stats
    def self.extended(obj)
      super
      obj._init_equipable
    end

    def _init_equipable
      @equip_stats=Hash.new(0)
    end

    def initialize(*)
      super
      _init_equipable
    end

    def _to_xml(xml)
      super
      xml.equipable{
        xml.stats{
          @equip_stats.each{|name,v|
            xml.stat(v,:name=>name)
          }
          _to_xml_equipable_stats(xml)
        }
        _to_xml_equipable(xml)
      }
    end
    
    def _parse_xml_equipable(node)
    end
  end
end

module Game
  module EquipableItem
  	def _init_equipable
  	end
  	
    def equip_stat(key)
      return stat(key,rpg.equip_stats[key],:equip)
    end
    
    def self.extended(obj)
    	super
			obj._init_equipable
    end
    chain "EquipableItem" do
    	def initialize(*)
    		super
				_init_equipable
    	end
    end
    
  end
end
