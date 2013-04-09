require_relative "baseitem"

module RPG
	module Inventar

	end
end

module Game
	module Inventar
		attr_reader :items
		def gain_item(item)
			if item.is_a?(Symbol)
				n=RPG::BaseItem[item].class.name.split("::").last
				temp = Game.const_get(n).new(item)
				@items[item] += [temp]
				cs_gained_item(temp)
			else
				@items[item.rpg.name] += [item]
				cs_gained_item(item)
			end
			return self
		end

		def lose_item(item)
			if item.is_a?(Symbol)
				cs_losed_item(@items[item].shift)
			else
				@items[item.rpg.name].delete(item)
				cs_losed_item(item)
			end
		end

		private

		def inventar_cs_init
			@items = Hash.new([])
		end
	end
end