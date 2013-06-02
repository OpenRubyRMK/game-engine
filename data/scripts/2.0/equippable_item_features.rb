require_relative "battler_equip"
require_relative "battler_feature"

module RPG
  module EquippableItem
    attr_accessor :equip_features
    chain "EquipFeatureInfluence" do
      def _init_equippable
        super
        @equip_features = []
      end
    end
  end
end

module Game
  module EquippableItem
    attr_reader :equip_features

    chain "EquipFeatureInfluence" do
      def _init_equippable
        super
        @equip_features = rpg.equip_features.map{|n| Feature.new(n) }
      end

    end
  end

  class Battler
    chain "EquipFeatureInfluence" do
      def features
        super + equips.each_value.map{|item|item.equip_features}.flatten
      end

    end
  end
end