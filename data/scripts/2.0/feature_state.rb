require_relative "battler_feature"
require_relative "battler_state"

module RPG
  class Feature

    attr_accessor :auto_states
    attr_accessor :states_chance
    attr_accessor :suspend_states

    chain "StateInfluence" do
      def initialize(*)
        super
        @auto_states = []
        @suspend_states = []
        @states_chance = Hash.new(1.0)
      end

      def _to_xml(xml)
        super

        xml.states_chance{
          @states_chance.each{|n,v| xml.state(v,:name=>n) }
        }

        xml.auto_states{
          @auto_states.each{|n| xml.state(:name=>n) }
        }

        xml.suspend_states{
          @suspend_states.each{|n| xml.state(:name=>n) }
        }

      end

      def _parse_xml(feature)
        super

        feature.xpath("states_chance/state").each {|node|
          @states_chance[node[:name].to_sym] = node.text.to_f
        }

        feature.xpath("auto_states/state").each {|node|
          @auto_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }

        feature.xpath("suspend_states/state").each {|node|
          @suspend_states << node[:name].to_sym
        }

      end
    end
  end
end

module Game
  class Feature

    attr_reader :states_chance
    attr_reader :suspend_states

    chain "StateInfluence" do
      def initialize(rpg)
        super
        @states_chance = rpg.states_chance
        @suspend_states = rpg.suspend_states
        @auto_states = rpg.auto_states.map{|n| State.new(n) }.group_by(&:name)
      end
    end

    def states(key)
      key ? @auto_states[key] || [] : @auto_states.values.flatten
    end

  end

  class Battler
    chain "FeatureStateInfluence" do
      def _states_chance(key)
        super + features.map {|f|
          key ? f.states_chance[key] || [] : f.states_chance
        }.flatten
      end

      def _states(key)
        super + features.map {|f| f.states(key)}.flatten
      end

      def _suspended_states
        super + features.map {|f| f.suspend_states }.flatten
      end
    end
  end
end