module RPG
	module UsableItem
		attr_accessor :max_uses
		attr_writer :consumable,:occasion,:remove_if_empty,:empty_price,:empty_weight
		
		def remove_if_empty
			return @remove_if_empty.nil? ? true : @remove_if_empty
		end
		def empty_price
			return @empty_price.nil? ? 0 : @empty_price
		end
		
		def consumable
			return @consumable.nil? ? true : @consumable
		end
		def occasion
			return @occasion.nil? ? 0 : @occasion
		end

		def battle_ok?
			return [0, 1].include?(@occasion)
		end
		def menu_ok?
			return [0, 2].include?(@occasion)
		end
		
		def empty_items
			@empty_items = Proxy.new({},BaseItem,Integer) if @empty_items.nil?
			return @empty_items
		end
		def empty_items=(value)
			@empty_items.replace(value)
			return value
		end
		
		def empty_weight
			return @empty_weight.nil? ? 0 : @empty_weight
		end
	end
end
module Game
	module UsableItem
		attr_reader :uses
		def consumable
			return data.consumable
		end
		def max_uses
			return data.max_uses
		end
		def occasion
			return data.occasion
		end
		def usable?
			return false if uses == 0
			return true
		end
		def fill_uses
			@uses=max_uses
			return nil
		end
		
		def uses=(value)
			@uses=[value,0].max
			return @uses
		end
		
		def remove_if_empty
			return data.remove_if_empty
		end
		
		def empty_items
			return nil if data.empty_items.nil?
			result = Proxy.new(Hash.new([]),RPG::BaseItem,Game::BaseItem)
			data.empty_items.each { |item,n| n.times { result[item] += [n] }}
			return result
		end
		private
		def usable_cs_stat_add(stat)
			return data.respond_to?("empty_#{stat}") ? data.send("empty_#{stat}") : 0
		end
		
		def usable_cs_stat_multi(stat)
			return data.respond_to?("empty_#{stat}") && !@uses.nil? ? @uses : 1
		end
	end
end