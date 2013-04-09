require_relative "battler_ability"
require_relative "battler_skill"
module RPG
	class Ability
		attr_accessor :skills
		private
		def skills_cs_init
			@skills = Hash.new([])
		end
		
		def skills_cs_to_xml(xml)
			xml.skills{
				@skills.each{|l,o| o.each{|k| xml.skill(:name=>k,:level=>l) } }
			}
		end
		
		def skills_cs_parse(enemy)
			enemy.xpath("skills/skill").each {|node|
				@skills[node[:level].to_i] += [node[:name].to_sym]
				Skill.parse_xml(node) unless node.children.empty?
			}
		end
	end
end

module Game
	class Ability
		def skills
			result = {}
			level.times {|l|
				@skills[l].each{|k,v|temp[k]=v }
			}
			return result
		end
		private
		def skills_cs_init
			@skills = Hash.new({})
			
			rpg.skills {|l,o|
				@skills[l] = @skills.default.dup
				o.each{|k| @skills[l][k] = Game::Skill.new(k)}
			}
		end
	end
	class Battler
		private
		def ability_cs_skills
			temp = Hash.new([])
			abilities.each_value{|o| o.each{|a| a.skills.each{|k,v| temp[k] += [v] }}}
			return temp
		end
	end
end
