require_relative "actorclass"
require_relative "battler_feature"
require_relative "levelable_feature"


module RPG
  class ActorClass
    include Featureable
  end
end

module Game
  class ActorClass
    include Featureable
    def features
      list = (0).upto(level).flat_map {|l|
        l = @levels[l]
        l.nil? ? [] : Array(l.features)
      }
      
      return super + list
    end
  end

  class Actor
    chain "ActorClassFeatureInfluence" do
      def features
        super + @actorclasses.each_value.flat_map(&:features)
      end
    end
  end
end
