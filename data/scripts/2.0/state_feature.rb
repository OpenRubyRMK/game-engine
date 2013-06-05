require_relative "battler_state"
require_relative "battler_feature"

module RPG
  class State
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
        enemy.xpath("features/feature").each {|node|
          @features << Feature.parse_xml(node)
        }
      end

    end
  end
end

module Game
  class State
    attr_reader :features
    chain "StateFeatureInfluence" do
      def initialize(*)
        super
        @features = rpg.features.map {|f| Feature.new(f) }
      end
    end
  end

  class Battler
    chain "StateFeatureInfluence" do
      def _features
        super + states.values.flat_map {|s| s.features }.flatten
      end

    end
  end
end