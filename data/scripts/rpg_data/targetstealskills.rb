require "target"
require "battlerskills"

module RPG
	class Target
		attr_proxy :steal_skills_any,:steal_skills_enemy,:steal_skills_ally
		
		private
		def stealskills_cs_init
			@steal_skills_any = Proxy.new(Hash.new(0),Skill,Float)
			@steal_skills_enemy = Proxy.new(Hash.new(0),Skill,Float)
			@steal_skills_ally = Proxy.new(Hash.new(0),Skill,Float)
		end
	end
end

module Game
	class Battler
		private
		def stealskills_cs_init
			@steal_lose_skills = Proxy.new([],RPG::Skill)
			@steal_get_skills = Proxy.new({},RPG::Skill,Game::Skill)
		end
		
		
		def stealskills_cs_skills
			result = Hash.new([])
			@steal_get_skills.each {|rskill,gskills| result[rskill] +=[gskills]}
			return result
		end
		


		def stealskills_cs_can_use_all(skill)
			case skill
			when RPG::Skill
				return false if @steal_lose_skills.include?(skill)
			when Game::Skill
				return false if @steal_lose_skills.include?(skill.data)
			end
			return true
		end

		def stealskills_cs_can_use_any(skill)
			case skill
			when RPG::Skill
				return @steal_get_skills.include?(skill)
			when Game::Skill
				return @steal_get_skills[skill.data] == skill
			end
			return false
		end
	end
end