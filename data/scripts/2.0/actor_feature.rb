require_relative "actor"
require_relative "battler_feature"

module RPG
  class Actor
    attr_accessor :features
    chain "FeatureInfluence" do
      def initialize(*)
        super
        @features = []
      end

      def _to_xml(xml)
        super
        xml.features {
          @features.each { |feature|
            feature.to_xml(xml)
          }
        }
      end
      def parse_xml(enemy)
        super
        actor.xpath("features/feature").each {|node|
          @features << Feature.parse_xml(node)
        }
      end

    end
  end
end

module Game
  class Actor
    chain "FeatureInfluence" do
      def initialize(*)
        super
        @actor_features = rpg.features.map {|f| Game::Feature.new(f)}
      end

      def _features
        super + @actor_features
      end
    end
  end
end