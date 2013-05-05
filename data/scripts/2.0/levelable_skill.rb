require_relative "levelable"
require_relative "skill"

module RPG
  module Levelable
    class Level
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
  
        def _parse_xml(level)
          super
          level.xpath("skills/skill").each {|node|
            @skills << node[:name].to_sym
            Skill.parse_xml(node) unless node.children.empty?
          }
        end
      end
    end
  end
end

module Game
  module Levelable
    class Level
      attr_reader :skills
      chain "SkillInfluence" do
        def initialize(rpg)
          super
          @skills = rpg.skills.map {|n|Skill.new(n)}.group_by(&:name)
        end
      end
    end
  end
end