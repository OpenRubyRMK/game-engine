require_relative "actor"
require_relative "battler_feature"
require_relative "featureable"

module RPG
  class Actor
    include Featureable
  end
end

module Game
  class Actor
    include Featureable
    
    chain "FeatureInfluence" do
      def _features
        super + @features
      end
    end
  end
end
