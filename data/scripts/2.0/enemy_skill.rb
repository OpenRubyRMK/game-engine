require_relative "enemy"
require_relative "battler_skill"

module RPG
  class Enemy
    attr_accessor :skills
    private
    chain "SkillInfluence" do
      def initialize(*)
        super
        @skills = []
      end

      def _to_xml(xml)
        super
        xml.skills{
          @skills.each{|k| xml.skill(:name=>k) }
        }

      end

      def _parse_xml(enemy)
        super
        enemy.xpath("skills/skill").each {|node|
          @skills << node[:name].to_sym
          Skill.parse_xml(node) unless node.children.empty?
        }
      end
    end
  end
end

module Game
  class Enemy
    chain "SkillInfluence" do
      def initialize(*)
        super
        rpg.skills.each {|n| add_skill(n)}
      end
    end
  end
end
