require "proxy"
require "baseitem"

module RPG	
	module EquipableItem
		attr_accessor :cursed,:max_durability,:remove_if_destroyed
		attr_accessor :atk,:spi,:def,:agi
		attr_accessor :durability_atk,:durability_spi,:durability_def,:durability_agi
		def destroyed_item
			@destroyed_item = Proxy.new({},BaseItem,Integer) if @destroyed_item.nil?
			return @destroyed_item
		end
		def destroyed_item=(value)
			destroyed_item.replace(value)
			return value
		end
	end
end
module Game
	module EquipableItem
		attr_writer :durability
		def max_durability
			data.max_durability
		end
		def durability
			return @durability.nil? ? max_durability.nil? ? nil : max_durability : [0,@durability].max
		end
		def cursed
			return data.cursed || cs_cursed.any?
		end
		
		def remove_if_destroyed
			return data.remove_if_destroyed
		end
		def destroyed_item
			result = Hash.new([])
			data.destroyed_item.each { |ritem,n| n.times { result[ritem] += [ritem.newGameObj] } }
			return result
		end
		def atk
			temp = data.atk
			cs_stat_multi(:atk) {|i| temp *= i}
			cs_stat_add(:atk) {|i| temp += i}
			return temp
		end
		def spi
			temp = data.spi
			cs_stat_multi(:spi) {|i| temp *= i}
			cs_stat_add(:spi) {|i| temp += i}
			return temp
		end
		def def
			temp = data.def
			cs_stat_multi(:def) {|i| temp *= i}
			cs_stat_add(:def) {|i| temp += i}
			return temp
		end
		def agi
			temp = data.agi
			cs_stat_multi(:agi) {|i| temp *= i}
			cs_stat_add(:agi) {|i| temp += i}
			return temp
		end
		
		#cs includes
		
		private
		def durability_cs_stat_multi(stat)
			return 1 unless data.respond_to?("durability_#{stat}")
			return (@durability.nil? ? 1 : (1 - data.send("durability_#{stat}") * durability / max_durability))
		end
		
	end
end