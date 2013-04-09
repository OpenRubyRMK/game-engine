require "actorrecipe"
require "battlerinventar"
module Game
	class Actor
		private
		def items_cs_recipe_args(args)
			args << self.inventar unless args.any?{|o|o.is_a?(Inventar)}
		end
		def items_cs_recipe_check(recipe,args)
			inv = args.find {|o|o.is_a?(Inventar)}
			recipe.ingredients.each do |item,n|
				return false if item.is_a?(RPG::InventarableItem) && inv.item_number(item) < n
			end
			recipe.tools.each do |item,n|
				return false if item.is_a?(RPG::InventarableItem) && inv.item_number(item) < n
			end
			return true
		end
		def items_cs_recipe_make(recipe,args)
			inv = args.find {|o|o.is_a?(Inventar)}
			recipe.ingredients.each do |item,n|
				inv.lose_item(item,n) if item.is_a?(RPG::InventarableItem)
			end
			recipe.results.each do |item,n|
				inv.gain_item(item,n) if item.is_a?(RPG::InventarableItem)
			end
		end
	end
end