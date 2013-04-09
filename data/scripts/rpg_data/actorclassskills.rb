require_relative "battlerskills"
require_relative "actoractorclass"
require_relative "proxy"
class RPG::ActorClass
	attr_proxy :skills
	private
	def actorclassskill_cs_init#:nodoc:
		@skills = Proxy.new({},Integer,Proxy.new([],RPG::Skill))
	end
end

class Game::ActorClass
	def skills
		result = Hash.new([])
		cs_skills.each {|hash| hash.each{|k,v| result[k]+=v}}
		return result
	end	
	private
	def actorclassskill_cs_init#:nodoc:
		@skills = Proxy.new({},RPG::Skill,Game::Skill)
	end
	def actorclassskill_cs_skills#:nodoc:
		result = Hash.new([])
		@skills.each {|rskill,gskill| result[rskill] += [gskill] }
		return result
	end
	def actorclassskill_cs_can_use_any(skill)#:nodoc:
		case skill
		when RPG::Skill
			return @skills.include?(skill)
		when Game::Skill
			return @skills[skill.data] == skill
		end
		return false
	end
	def actorclassskill_cs_levelup#:nodoc:
		self.data.skills[@level].each {|skill| @skills[skill]=skill.newGameObj}
	end
end

class Game::Actor
	private
	def actorclassskill_cs_skills#:nodoc:
		result = Hash.new([])
		@actorclass.each_values {|ac| ac.skills.each {|rskill,gskill| result[rskill]=[gskill] }}
		return result
	end
	def actorclassskill_cs_can_use_any(skill)#:nodoc:
		return @actorclass.any?{|rac,gac| gac.cs_can_use_any(skill).any?}
	end
end