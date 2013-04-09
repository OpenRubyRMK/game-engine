require_relative "csmod"
require_relative "gameclasses"
module Game
 	class Battler
		include Game::GameClasses

		def initialize(battler)
			self.data = battler #data is defined in sup classes
			cs_init_pre
			cs_init
			cs_init_post
		end
	 	def name
			data.name
		end
		
		def atk
			temp = baseAtk
			cs_stat_multi(:atk) {|i| temp *= i}
			cs_stat_add(:atk) {|i| temp += i}
			return temp
		end

		def spi
			temp = baseSpi
			cs_stat_multi(:spi) {|i| temp *= i}
			cs_stat_add(:spi) {|i| temp += i}
			return temp
		end
		
		def def
			temp = baseDef
			cs_stat_multi(:def) {|i| temp *= i}
			cs_stat_add(:def) {|i| temp += i}
			return temp
		end

		def agi
			temp = baseAgi
			cs_stat_multi(:agi) {|i| temp *= i}
			cs_stat_add(:agi) {|i| temp += i}
			return temp
		end
 	end
end