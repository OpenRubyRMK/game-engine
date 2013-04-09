require "battlerability"
require "equipment"
require "equipableitem"
module RPG
	module EquipableItem
		def abilities
			@abilities =Proxy.new({},Ability,Integer) if @abilities.nil?
			return @abilities
		end
		def abilities=(value)
			abilities.replace(value)
		end
	end
# 	class Equipment
# 		attr_reader :dualhand_abilities
# 		def dualhand_abilities=(value)
# 			@dualhand_abilities.replace(value)
# 			return value
# 		end
# 		private
# 		def abilities_cs_init
# 			@dualhand_abilities = Proxy.new({},Ability,Integer) #RPG::Ability => level
# 		end
# 	end
end
module Game
	class Equipment
		private
		def ability_cs_equipable?(slot,item)
			case item
			when RPG::EquipableItem
				item.abilities.each do |abi,i|
					return false unless actor.abilities.include?(abi) && actor.abilities[abi].level >= i
				end
			when Game::EquipableItem
				item.data.abilities.each do |abi,i|
					return false unless actor.abilities.include?(abi) && actor.abilities[abi].level >= i
				end
			end
			return true
		end
	end
end