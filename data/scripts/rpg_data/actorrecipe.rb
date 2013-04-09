require "recipe"
require "actor"

module Game
	class Actor
		attr_reader :recipes
		def recipes=(value)
			@recipes.replace(value)
		end

		def learn_recipe(recipe)
			return if recipe_learned?(recipe)
			@recipes[recipe]=0
		end
		def recipe_learned?(recipe)
			return @recipes.include?(recipe)
		end
		def recipe_can_make?(recipe,*args)
			cs_recipe_args(args)
			return cs_recipe_check(recipe,args).all?
		end
		def recipe_make(recipe,*args)
			return recipe_can_make?(recipe,*args)
			cs_recipe_make(recipe,args)
		end
		private
		def need_learned_cs_recipe_check(recipe,args)
			return recipe_learned?(recipe) || !recipe.need_learned
		end
		def recipes_cs_init
			@recipes=Proxy.new(Hash.new(0),RPG::Recipe,Integer)
		end
	end
end