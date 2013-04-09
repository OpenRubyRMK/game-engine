require "proxy"
require "baseitem"
require "inventarableitem"
require "usableitem"
module Game
	class Inventar
		def initialize
			@items = Proxy.new(Hash.new([]),RPG::BaseItem)
		end
		
		def gain_item(item,n=1)
			case item
			when RPG::BaseItem
				return unless item.is_a?(RPG::InventarableItem)
				n.times {gain_item(item.newGameObj)}
			when Game::BaseItem
				return unless item.is_a?(Game::InventarableItem)
				@items[item.data] +=[item]
			end
			return self
		end
		def lose_item(item,n=1)
			case item
			when RPG::BaseItem
				return unless item.is_a?(RPG::InventarableItem)
				n.times {@items[item.data].shift}
			when Game::BaseItem
				return unless item.is_a?(Game::InventarableItem)
				@items[item.data].delete(item)
			end
			return self
		end
		def item_number(item)
			case item
			when RPG::InventarableItem
				return @items[item].size
			when Game::InventarableItem
				return @items[item.data].count(item)
			else
				return 0
			end
		end
		def consume_item(item)
			case item
			when RPG::UsableItem
				game_item = @items[item][0]
			when Game::UsableItem
				game_item = item
			else
				return nil
			end
			if game_item.consumable && game_item.usable?
				unless game_item.uses.nil?
					game_item.uses -= 1 
					return if game_item.uses > 0
				end
				lose_item(game_item) if game_item.remove_if_empty
				game_item.empty_items.each {|ritem,gitem| gitem.each {|i| gain_item(i)}}
			end
		end
		
		def [](rpg_item)
			return @items[rpg_item]
		end
		
		def each(item=nil,&block)
			if item.nil?
				return @items.each(&block)
			else
				return nil unless @items.include?(item)
				return @items[item].each(&block)
			end
		end
	end
end