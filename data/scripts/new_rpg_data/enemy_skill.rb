require_relative "battler_skill"
require_relative "enemy"

module RPG
	class Enemy
		attr_accessor :skills
		private
		def skills_cs_init
			@skills = []
		end
		
		def skills_cs_to_xml(xml)
			xml.skills{
				@skills.each{|k| xml.skill(:name=>k) }
			}
		end
		
		def skills_cs_parse(enemy)
			enemy.xpath("skills/skill").each {|node|
				@skills << node[:name].to_sym
				Skill.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	class Enemy
		private
		def enemy_skills_cs_init_after
			rpg.skills.each{|n| add_skill(n) }
		end
	end
end
