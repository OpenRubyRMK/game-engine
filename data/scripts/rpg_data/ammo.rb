require "socket.rb"

module RPG
	module AmmoableItem
		#include for weapons
		def ammo
			@ammo ||= Socket.find_index(Socket.new)
			return Socket[@ammo]
		end
	end
end

module Game
	module AmmoableItem
		def ammo
			return @ammo.item
		end
		def ammo=(value)
			return @ammo.item = value
		end
		def ammoable?(item)
			case item
			when RPG::UsableItem
				return @ammo === item
			when Game::UsableItem
				return @ammo === item.data
			else
				return false
			end
		end
		
		private
		def ammoable_cs_init#:nodoc:
			@ammo = Socket.new(data.ammo)
		end
		def ammo_cs_stat_add(stat)#:nodoc:
			if ammo.respond_to?("ammo_#{stat}")
				return ammo.send("ammo_#{stat}")
			elsif ammo.respond_to?("#{stat}")
				return ammo.send("#{stat}")
			else
				return 0
			end
		end
	end
end