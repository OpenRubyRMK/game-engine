require_relative "enemy"
require_relative "battler_feature"
require_relative "featureable"

module RPG
  class Enemy
    include Featureable
  end
end

module Game
  class Enemy
    include Featureable
    
    chain "FeatureInfluence" do
      def _features
        super + @features
      end
    end
  end
end
