require_relative "enemy_feature"
require_relative "feature_state"

module RPG
  class Enemy

    attr_accessor :dead_state
        
    chain "StateInfluence" do
      def initialize(*)
        super
        @dead_state = nil
      end

      def _to_xml(xml)
        super
        xml.dead_state(:name=>@dead_state)

      end

      def _parse_xml(enemy)
        super
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
    
    def dead_state
      return rpg.dead_state
    end
    
  end
end
