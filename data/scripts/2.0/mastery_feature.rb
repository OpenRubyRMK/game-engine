require_relative "battler_mastery"
require_relative "battler_feature"
require_relative "levelable_feature"

module RPG
  class Mastery
    include Featureable
  end
end

module Game
  class Mastery
    include Featureable
    
    def features
    	return super + (0).upto(level).flat_map {|l| Array(l.features) }
    end
  end

  class Battler
    chain "AbilityFeatureInfluence" do
      def features
        super + active_mastery.each_value.flat_map(&:features)
      end
    end
  end
end
