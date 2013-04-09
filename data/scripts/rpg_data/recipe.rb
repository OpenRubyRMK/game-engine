require "rpgclasses"
require "baseitem"
module RPG
	class Recipe
		include RPGClasses
		attr_reader :ingredients, :results, :tools
		attr_accessor :need_learned
		def initialize
			@ingredients = Proxy.new(Hash.new(0),BaseItem,Integer)
			@results = Proxy.new(Hash.new(0),BaseItem,Integer)
			@tools = Proxy.new(Hash.new(0),BaseItem,Integer)
			@need_learned = true
			cs_init
		end
		
		def ingredients=(value)
			@ingredients.replace(value)
			return value
		end
		
		def results=(value)
			@results.replace(value)
			return value
		end
		
		def tools=(value)
			@tools.replace(value)
			return value
		end
	end
end