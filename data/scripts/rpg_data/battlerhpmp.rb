require "battler"

module Game
	class Battler
		attr_reader :hp,:mp
		
		def maxhp
			temp = basehp
			cs_stat_multi(:hp) {|i| temp *= i}
			cs_stat_add(:hp) {|i| temp += i}
			return temp
		end

		def maxmp
			temp = basemp
			cs_stat_multi(:mp) {|i| temp *= i}
			cs_stat_add(:mp) {|i| temp += i}
			return temp
		end
		
		def hp=(value)
			@hp = [[value, maxhp].min, 0].max
			cs_hp_change
		end
		
		def mp=(value)
			@mp = [[value, maxmp].min, 0].max
			cs_mp_change
		end
		
		private
		def hpmp_cs_init#_post
			@hp = self.basehp
			@mp = self.basemp
		end
	end
end