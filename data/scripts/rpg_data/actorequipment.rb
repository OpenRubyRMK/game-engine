require "battlerequipment"
require "actoractorclass"
module RPG
	class ActorClass
		attr_rpg :equipment,RPG::Equipment
		private
		def equipment_cs_init
			self.equipment=Equipment.new
		end
	end
	class Actor
		def equipment
			return actorclass[0].equipment
		end
	end
end