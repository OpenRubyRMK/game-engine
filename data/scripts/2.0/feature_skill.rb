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
  
	module Featureable
		def skills(key=nil)
			return _list_group_by(_featureable_helper {|f| f.skills(key)}, key)
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

      def skills(key = nil)
        key ? Array(@skills[key]) : @skills.values.flatten
      end
    end
  end
  
  module Featureable
		private

		def _featureable_skills(key,battler = nil)
			return _featureable_helper(battler) {|f| f.skills(key)}
		end
	end

	class Battler
		include Featureable
		chain "FeatureSkillInfluence" do

			def _skills(key)
				super + _featureable_skills(key)
			end
			def _available_skills(key)
				super + _featureable_skills(key, self)
			end
		end
	end
end
