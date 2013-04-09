require "usablerecipe"
require "actorrecipe"
require "actoractorclass"

module Game
	class Actor
		private
		def recipe_cs_item_use(user,item)
			item.data.learn_recipes.each do |ac,pr|
				if actorclass.include?(ac)
					pr.each do |l,arec|
						arec.each {|r| learn_recipe(r) } if actorclass[ac].level >= l
					end
				end
			end
		end
	end
end