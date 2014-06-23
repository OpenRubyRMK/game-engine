require_relative "battler_equip"
require_relative "battler_feature"
require_relative "featureable"
module RPG
  module EquippableItem
    include Featureable
  end
end

module Game
  module EquippableItem
    include Featureable
  end

  class Battler
    chain "EquipFeatureInfluence" do
      def features
        super + equips.each_value.flat_map(&:features)
      end

    end
  end
end
