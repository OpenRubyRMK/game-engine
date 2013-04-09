require_relative "battler"
#require_relative "socket"
require_relative "equipableitem"
module Game
	
	class Battler
	
		def equip(slot,item)
			cs_unequiped(slot,@sockets[slot]) unless @sockets[slot].nil?
			@sockets[slot]=item
			cs_equiped(slot,item)
			return self
		end
		
		def can_equip?(slot,item)
			return cs_can_equip(slot,item).all?
		end
		
		def add_socket(slot)
			@sockets[slot]=nil
			cs_socket_added(slot)
			return self
		end
		def equips
			equipment_cs_init if @sockets.nil?
			return @sockets.dup.delete_if{|k,v|v.nil?}
		end
		private
		def equipment_cs_init
			@sockets={}
			if rpg.respond_to?(:sockets)
				rpg.sockets.each{|s| add_socket(s) }
			end
		end
		
		def equipment_cs_stat_add(stat)
			return equips.values.map{|item| item.equip_stat(stat)}.inject(0,&:+)
		end
	end
end

