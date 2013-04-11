require_relative "enemy"
require_relative "battler_state"

module RPG
  class Enemy
    attr_accessor :auto_states
    attr_accessor :states_chance #manange the imunity
    attr_accessor :dead_state
    private
    chain "StateInfluence" do
      def initialize(*)
        super
        @auto_states = []
        @states_chance = Hash.new(1.0)
        @dead_state = nil
      end
      def _to_xml(xml)
        super
        xml.states_chance{
          @states_chance.each{|n,v| xml.state(v,:name=>n) }
        }
        xml.auto_states{
          @auto_states.each{|n| xml.state(:name=>n) }
        }
        xml.dead_state(:name=>@dead_state)
        
      end
          
      def _parse_xml(enemy)
        super
        enemy.xpath("states_chance/state").each {|node|
          @state_chance[node[:name].to_sym] = node.text.to_f
        }
        enemy.xpath("auto_states/state").each {|node|
          @auto_states << node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }
        enemy.xpath("dead_state").each {|node|
          @dead_state = node[:name].to_sym
          State.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Enemy
    chain "StateInfluence" do
      def initialize(*)
        super
        @auto_states = rpg.auto_states.map{|n| State.new(n) }.group_by(&:name)
      end
      
      def _states(key)
        super + (key ? @auto_states[key] || [] : @auto_states.values.flatten) 
      end
      
      def _states_chance(key)
        return super + [(key ? rpg.states_chance[key] : rpg.states_chance)]
      end
    end

    def dead_state
      return rpg.dead_state
    end
  end
end
