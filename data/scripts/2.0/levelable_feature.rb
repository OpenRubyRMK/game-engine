require_relative "levelable"
require_relative "feature"

module RPG
  module Levelable
    class Level
      attr_accessor :features
      chain "FeatureInfluence" do
        def initialize(*)
          super
          @features = []
        end
        
        def _to_xml(xml)
          super
          xml.features{
            @features.each{|feature| feature.to_xml(xml)}
          }
        end
  
        def _parse_xml(level)
          super
          level.xpath("features/feature").each {|node|
          @features << Feature.parse_xml(node)
        }
        end
      end
    end
  end
end

module Game
  module Levelable
    class Level
      attr_reader :features
      chain "FeatureInfluence" do
        def initialize(rpg)
          super
          @features = rpg.features.map {|n|Feature.new(n)}
        end
      end
    end
  end
end