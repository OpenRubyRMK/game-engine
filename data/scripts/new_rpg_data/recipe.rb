require_relative "baseobject"
require_relative "baseitem"
require_relative "actor"
#require_relative "inventar"
module RPG
	class Recipe < BaseObject
		attr_accessor :ingredients,:results,:needlearned
		
		def recipe_cs_init
			@ingredients= {} # itemid => anzahl
			@results = {} # itemid => anzahl
			@needlearned = false
		end
	end
	class Actor
		attr_accessor :recipes
		private
		def recipe_cs_init
			@recipes = []
		end
	end
end


module Game
	class Actor
		
		attr_reader :learned_recipes
		def recipe_can_make?(recipe,cart)
			return cs_recipe_can_make(RPG::Recipe[recipe.to_sym],cart).all?
		end

		def make_recipe(recipe,cart=self)
			if recipe_can_make?(recipe,cart)
				cs_make_recipe(RPG::Recipe[recipe.to_sym],cart)
			end
			return self
		end
		def recipe_learned?(recipe)
			return @learned_recipes.include?(recipe.to_sym)
		end
		def learn_recipe(recipe)
			unless recipe_learned?(recipe)
				@learned_recipes << (recipe.to_sym)
				cs_recipe_learned(recipe.to_sym)
			end
		end

		private
		def recipes_cs_init
			@learned_recipes = []
			rpg.recipes.each{|r| learn_recipe(r) }
		end
		def learned_cs_recipe_can_make(recipe,*)
			return recipe_learned?(recipe) if recipe.needlearned
			return true
		end
		def ingredients_cs_recipe_can_make(recipe,cart)
			return recipe.ingredients.all? {|item,n| cart.items[item].size >=n }
		end
		def ingredients_cs_make_recipe(recipe,cart)
			recipe.ingredients.each {|item,n|
				n.times{ cart.remove_item(item) }
			}
		end
		def results_cs_make_recipe(recipe,cart)
			recipe.results.each {|item,n|
				n.times{ cart.gain_item(item) }
			}
		end
		def learned_cs_make_recipe(recipe,*)
			learn_recipe(recipe)
		end
	end
end
