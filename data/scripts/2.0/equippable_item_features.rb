require_relative "battler_equip"
require_relative "battler_feature"

module RPG
  module EquippableItem
  	attr_reader :equipable_features
  
  	chain "EquipFeatureInfluence" do
  		def initialize(*)
  			super
  			@equipable_features = FeatureHolder.new
  		end
  		
  		def _to_xml_equippable(xml)
        super
        xml.equipable_features {
        	@equipable_features.to_xml(xml)
        }
      end

      def _parse_xml_equippable(item)
        super
        item.xpath("equipable_features").each {|node|
          @equipable_features.parse_xml(node)
        }
      end
  		
  	end
  	
  end
end

module Game
  module EquippableItem
  	attr_reader :equipable_features
    chain "FeatureInfluence" do
    	def initialize(*)
  			super
  			@equipable_features = FeatureHolder.new(rpg.equipable_features)
  		end
    end
  end

  class Battler
    chain "EquipFeatureInfluence" do
      def features
        super + equips.each_value.flat_map{|e| e.equipable_features.features }
      end

    end
  end
end
