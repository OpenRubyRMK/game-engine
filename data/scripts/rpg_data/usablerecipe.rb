require "usableitem"
require "recipe"
require "actorclass"
module RPG
	module UsableItem
		def learn_recipes
			@learn_recipes = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Recipe))) if @learn_recipes.nil?
			return @learn_recipes
		end
		def learn_recipes=(value)
			learn_recipes.replace(value)
			return value
		end
	end
end