require_relative "enemy"

require_relative "chain_module"

module RPG
  class Enemy
    attr_accessor :swap_enemies
    private
    chain "SwapEnemyInfluence" do
      def initialize(*)
        super
        @swap_enemies = {}
      end

      def _to_xml(xml)
        super
        xml.swap_enemies{
          @swap_enemies.each{|v,k| xml.enemy(:name=>k,:variant => v) }
        }

      end

      def _parse_xml(enemy)
        super
        enemy.xpath("swap_enemies/enemy").each {|node|
          @swap_enemies[node[:name].to_f] = node[:name].to_sym
          Enemy.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Enemy
    chain "SwapEnemyInfluence" do
      def initialize(name)
        se = RPG::Enemy[name].swap_enemies
        v = rand(0..se.values.inject(0,:+))
        super(se.inject(nil){|m,(k,v)| break k if r < m.to_f + v; m.to_f + v} || name)
      end
    end
  end
end
