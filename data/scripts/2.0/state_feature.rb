require_relative "battler_state"
require_relative "battler_feature"

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
      def features
        super + states.values.flatten.flat_map(&:features)
      end

    end
  end
end
