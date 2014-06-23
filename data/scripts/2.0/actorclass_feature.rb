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
      list = (0).upto(level).map {|l|
        l = @levels[l]
        l.nil? ? [] : l.features
      }.compact.flatten
      
      return super + list
    end
  end

  class Actor
    chain "ActorClassFeatureInfluence" do
      def _features
        super + @actorclasses.each_value.map{|ac| ac.features }.flatten
      end
    end
  end
end
