require_relative "battlerskills"

module RPG
	class Skill
		attr_accessor :cannot_draw,:draws,:max_draws
		private
		def draw_cs_init#:nodoc:
			@draws = 0
			@max_draws = 100
			@cannot_draw = false
		end
	end
end
module Game
	module DrawSkill
		attr_accessor :draw_charges
	end
	class Battler
		private
		def draws_cs_use(user,skill,target,key)#:nodoc:
			skill.draw_charges -=1 if skill.is_a?(DrawSkill)
		end
	end
	class Actor
		def draw_skill(skill,charges) #rpg::skill
			return unless could_draw?(skill)
			if @draw_skills.include?(skill)
				temp = @draw_skills[skill].draw_charges
				temp = [temp,skill.max_draws].min
				@draw_skills[skill].draw_charges = temp
			else
				temp = skill.newGameObj
				temp.extend(DrawSkill)
				temp.draw_charges = [charges,skill.max_draws].min
				@draw_skills[skill] = temp
			end
		end
		def could_draw?(skill)
			return cs_could_draw(skill).all?
		end
		private
		def cannot_cs_could_draw(skill)#:nodoc:
			return !skill.cannot_draw
		end
		def draw_cs_mp_cost_multi(skill)#:nodoc:
			return skill.is_a?(DrawSkill) ? 0 : 1
		end
		def draw_cs_init#:nodoc:
			@draw_skills =Proxy.new({},RPG::Skill,Game::Skill)
		end
		def draw_cs_skills#:nodoc:
			result = Hash.new([])
			@draw_skills.each {|rskill,gskill| result[rskill]=gskill}
			return result
		end
		def draw_cs_can_use_all(skill)#:nodoc:
			return true unless skill.is_a?(DrawSkill)
			return skill.draw_charges > 0
		end
	end
end