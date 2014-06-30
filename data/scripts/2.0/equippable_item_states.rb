require_relative "equippable_item_features"
require_relative "feature_state"
require_relative "requirement_states"

module Game
  module EquippableItem
    def states_chance
      equip_features.map {|f| f.states_chance }.inject(Hash.new(1.0)) do |element,hash|
        hash.merge(element) {|k,o,n| o * n}
      end
    end
    
    def auto_states(key=nil)
      list = equip_features.flat_map {|f| f.states(key) }
      return key ? list : list.group_by(&:name)
    end
  end
end
