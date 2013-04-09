require_relative "battlerskills"
require_relative "battlerability"
module RPG
	class Ability
		attr_proxy :skills
		private
		def skills_cs_init#:nodoc:
			@skills = Proxy.new({},Integer,Proxy.new([],Skill))
		end
	end
end
module Game
	class Ability
		def skills
			result = Hash.new([])
			cs_skills.each {|hash| hash.each{|k,v| result[k]+=v}}
			return result
		end
		private
		def ability_skills_cs_init#:nodoc:
			@ability_skills = Proxy.new({},RPG::Skill,Game::Skill)
		end
		def ability_skills_cs_skills#:nodoc:
			result = Hash.new([])
			@ability_skills.each {|rskill,gskill| result[rskill] +=[gskill] }
			return result
		end
		def ability_skills_cs_levelup#:nodoc:
			self.data.skills[@level].each {|skill| @ability_skills[skill] = skill.newGameObj}
		end
	end
	class Battler
		private
		def abilities_cs_skills#:nodoc:
			result = Hash.new([])
			@abilities.each{|ac,pr| pr.skills.each {|rskill,gskill| result[rskill] += [gskill] }}
			return result
		end
		def abilities_cs_can_use_any(skill)#:nodoc:
			case skill
			when RPG::Skill
				return @abilities.values.any?{|pr| pr.skills.include?(skill)}
			when Game::Skill
				return @abilities.values.any?{|pr| pr.skills[skill.data] == skill}
			end
			return false
		end
	end
end
