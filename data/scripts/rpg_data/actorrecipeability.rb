require_relative "battlerability"
require_relative "recipeability"
require_relative "actorrecipe"
module Game
	class Actor
		private
		def recipeskills_cs_recipe_check(recipe)
			recipe.abilities.each do |attri,n|
				return false if !abilities.include?(attri) || abilities[attri].level < n
			end
			return true
		end
	end
end