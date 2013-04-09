require "recipe"
require "ability"

module RPG
	class Recipe
		attr_reader :abilities
		def abilities=(value)
			@abilities.replace(value)
			return value
		end
		private
		def abilities_cs_init
			@abilities = Proxy.new({},RPG::Ability,Integer)
		end
	end
end