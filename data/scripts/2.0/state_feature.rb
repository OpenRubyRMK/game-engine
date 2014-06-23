require_relative "battler_state"
require_relative "battler_feature"
require_relative "featureable"
module RPG
  class State
    include Featureable
  end
end

module Game
  class State
    include Featureable
  end

  class Battler
    chain "StateFeatureInfluence" do
      #def _features
      #  super + states.values.flatten.map {|s| s.features }.flatten
      #end

    end
  end
end
