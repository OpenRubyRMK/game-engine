require_relative "battler_equip"
require_relative "battler_state"
require_relative "selector"

module RPG
  class State
    attr_reader :indestructible_item
    attr_reader :destructible_item
    
    chain "StateEquippableItemInfluence" do
      def initialize(*)
        super
        @indestructible_item = Selector.new
        @destructible_item = Selector.new
      end
      def _to_xml(xml)
        super
        xml.indestructible_item { @indestructible_item.to_xml(xml) }
        xml.destructible_item { @destructible_item.to_xml(xml) }
      end
    end
    
  end
end

module Game
  class Battler
    chain "StateEquippableItemInfluence" do
      def _item_indestructibly(item)
        super + _states(nil).map {|state| state.rpg.indestructible_item.check(item) }
      end

      def _item_destructibly(item)
        super + _states(nil).map {|state| state.rpg.destructible_item.check(item) }
      end
    end
  end
end