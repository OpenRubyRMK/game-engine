require_relative "battler_ability"
require_relative "battler_feature"
require_relative "levelable_feature"

module RPG
  class Ability
    include Featureable
  end
end

module Game
  class Ability
    include Featureable
    
    
    def features
    	list = super
      if l = @levels[level]
        list += Array(l.features)
      end
      return list
    end
  end

  class Battler
    chain "AbilityFeatureInfluence" do
      def features
        super + @abilities.each_value.flat_map(&:features)
      end
    end
  end
end
