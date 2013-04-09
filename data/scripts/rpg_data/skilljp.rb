require_relative "battlerskills"
require_relative "actorjp"
module RPG
	class Skill
		attr_accessor :jp_cost
		attr_proxy :jp_require_actorclass,:jp_require_skills
		private
		def jp_cs_init#:nodoc:
			@jp_cost = 0
			@jp_require_actorclass = Proxy.new(Hash.new(0),RPG::ActorClass,Integer)
			@jp_require_skills = Proxy.new([],RPG::Skill)
		end
	end
end
module Game
	class Battler
		private
		def skilljp_cs_init#:nodoc:
			@jpskills = Proxy.new({},RPG::Skill,Game::Skill)
		end
		def skilljp_cs_jp_can_learn(obj)#:nodoc:
			return true unless obj.respond_to?(:jp_require_skills)
			return obj.jp_require_skills.all? {|skill| self.skills.include?(skill)}
		end
		def skilljp_cs_jp_learn(skill)#:nodoc:
			return unless skill.is_a?(RPG::Skill)
			@jpskills[skill] = skill.newGameObj
		end
		def skilljp_cs_skills#:nodoc:
			result = Hash.new([])
			@jpskills.each{|rskill,gskill| result[rskill] = [gskill]}
			return result
		end
	end
end