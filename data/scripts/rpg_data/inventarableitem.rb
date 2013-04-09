module RPG
	module InventarableItem
		attr_accessor :dropable
		attr_writer :weight	
		def weight
			return @weight.nil? ? 0 : @weight
		end
	end
end
module Game
	module InventarableItem
		def weight
			temp = data.weight
			cs_stat_multi(:weight) {|i| temp *= i}
			cs_stat_add(:weight) {|i| temp += i}
			return temp
		end
		def dropable
			return data.dropable
		end
	end
end