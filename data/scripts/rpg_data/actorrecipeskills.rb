require "actorrecipe"
require "battlerskills"
module Game
	class Actor
		private
		def recipeskills_cs_skills
			result = {}#Hash.new([])
			@recipeskills.each{|rskill,gskill| result[rskill]=[gskill] }
			return result
		end
		def recipeskills_cs_can_use_any(skill)
			case skill
			when RPG::Skill
				return @recipeskills.include?(skill)
			when Game::Skill
				return @recipeskills[skill.data] == skill
			end
			return false
		end
		def recipeskills_cs_recipe_check(recipe,args)
			recipe.ingredients.each do |skill,n|
				return false if skill.is_a?(RPG::Skill) && skills[skill].size < n
			end
			recipe.tools.each do |skill,n|
				return false if skill.is_a?(RPG::Skill) && skills[skill].size < n
			end
			return true
		end
		def recipeskills_cs_recipe_make(recipe,args)
			recipe.results.each do |skill,*|
				@recipeskills[skill]= skill.newGameObj unless @recipeskills.include?(skill)
			end
		end
		def recipeskills_cs_init
			@recipeskills = Proxy.new({},RPG::Skill,Game::Skill)
		end
	end
end