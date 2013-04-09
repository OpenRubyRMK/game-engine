require_relative "enemy"
require_relative "equipment"
require_relative "baseitem"

module RPG
	class Enemy
		attr_proxy :default_equipment
		attr_rpg :equipment,RPG::Equipment
		private
		def equipment_cs_init#:nodoc:
			@equipment = Equipment.find_index(Equipment.new)
			@default_equipment = Proxy.new({},Symbol,BaseItem)
		end
	end
end

module Game
	class Enemy
		private
		def enemyequipment_cs_init_post#:nodoc:
			self.data.default_equipment.each do |key,item|
				@equipment.equip(key,item.newGameObj)
			end
		end
	end
end