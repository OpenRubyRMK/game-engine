require_relative "socket"
require_relative "proxy"
module RPG
	class Equipment
		include RPGClasses
		attr_accessor :fix_equipment
		attr_reader :sockets
		def initialize
			@sockets =Proxy.new({},Symbol,Socket) #symbol => RPG::Socket
			cs_init
			@fix_equipment = []
			Equipment.instances.push(self)
		end
		
		def sockets=(value)
			@sockets.replace(value)
			return value
		end
	end
end
module Game
	class Equipment
		include GameClasses
		attr_reader :sockets
		def initialize(equip,battler=nil)
			self.data = equip
			@battler = battler
			@sockets = {}
			self.data.sockets.each {|sym,socket|
				@sockets[sym] = Socket.new(socket)
			}
		end
		
		def items
			return sockets.map {|k,v| v.item}.compact
		end
		
		def stats(stat)
			temp=0
			sockets.each {|key, socket|
				unless (item = socket.item).nil?
					if item.respond_to?(stat)
						temp1 = item.send(stat)
						cs_stats_item_multi(stat,key,item){|i| temp1 *= i}
						cs_stats_item_percent(stat,key,item){|i| temp1 += i * item.send(stat) }
						cs_stats_item_add(stat,key,item){|i| temp1 += i}
						temp += temp1
					end
				end
			}
			cs_stats_multi(stat){|i| temp *= i}
			cs_stats_add(stat){|i| temp += i}
			return temp
		end
		
		def equip(slot,item)
			return nil unless @sockets.include?(slot)
			return nil unless equipable?(slot,item)
			cs_equip(slot,item)
			return @sockets[slot].item = item
		end
		def equipable?(slot,item)
			return false unless @sockets.include?(slot)
			return false if !@sockets[slot].item.nil? && self.data.fix_equipment.include?(slot)
			return false unless @sockets[slot] === item
			return cs_equipable?(slot,item).all?
		end
		def equip?(item,slot=nil)
			case item
			when RPG::BaseItem
				if slot.nil?
					return !@sockets.find {|key,slot| slot.item.data == item}.nil?
				else
					return false unless @sockets.include?(slot)
					@sockets[slot].item.data == item
				end
			when Game::BaseItem
				if slot.nil?
					return !@sockets.find {|key,slot| slot.item == item}.nil?
				else
					return false unless @sockets.include?(slot)
					@sockets[slot].item == item
				end
			else
				return false
			end
		end
		def skills
			result = Hash.new([])
			cs_skills.each {|hash| hash.each{|k,v| result[k]+=v}}
			return result
		end

	end
end