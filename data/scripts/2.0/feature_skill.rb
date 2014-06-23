require_relative "battler_feature"
require_relative "battler_skill"

module RPG
  class Feature
      
    attr_accessor :skills
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

      def parse_xml(enemy)
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
  class Feature
    chain "SkillInfluence" do
      def initialize(rpg)
        super
        @skills = rpg.skills.map{|n| Skill.new(n) }.group_by(&:name)
      end

      def skills(key)
        key ? @skills[key] || [] : @skills.values.flatten
      end
    end
  end

  class Battler
    chain "FeatureSkillInfluence" do
      def _skills(key)
        super + features.flat_map {|f| f.skills(key)}
      end
      def _available_skills(key)
        super + features.select {|f| f.requirement.check(self) }.flat_map {|f| f.skills(key)}
      end
    end
  end
end
