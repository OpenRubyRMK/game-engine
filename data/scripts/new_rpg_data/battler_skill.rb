require_relative "battler"
require_relative "skill"
module Game
	class Battler
		
		def skills
			result = Hash.new([])
			cs_skills {|o| o.each{|k,v| result[k] += v }}
			return result
		end
		
		def add_skill(k)
			temp = Skill.new(k)
			@skills[k] += [temp]
			cs_add_skill(k)
			return temp
		end
		
		def remove_skill(k)
			unless(@skills[k].empty?)
				temp = @skills[k].shift
				cs_remove_skill(k)
				return temp
			else
				return nil
			end
		end
		
		private
		def skill_cs_init
			@skills ||= Hash.new([])
		end
		
		def skill_cs_skills
			return @skills
		end
		
	end
end
