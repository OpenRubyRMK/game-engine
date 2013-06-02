require_relative "battler_feature"
require_relative "battler_state"

module RPG
  class Feature
    
    attr_accessor :auto_states
    
    chain "StateInfluence" do
      def initialize(*)
        super
        @auto_states = []
      end

      def _to_xml(xml)
        super
        xml.auto_states{
          @auto_states.each{|n| xml.state(:name=>n) }
        }

      end

      def _parse_xml(feature)
        super
        feature.xpath("auto_states/state").each {|node|
          @auto_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Feature
    chain "StateInfluence" do
      def initialize(rpg)
        super
        @auto_states = rpg.auto_states.map{|n| State.new(n) }.group_by(&:name)
      end

      def states(key)
        key ? @auto_states[key] || [] : @auto_states.values.flatten
      end
    end
  end

  class Battler
    chain "FeatureStateInfluence" do
      def _states(key)
        super + features.map {|f| f.states(key)}.flatten
      end
    end
  end
end