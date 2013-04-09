require_relative "battlerhpmp"
require_relative "target"

module RPG
	class Target
		attr_accessor :hp_cost,:mp_cost
		private
		def hpmp_cs_init
			@hpcost = 0
			@mpcost = 0
		end
	end
end

module Game
	class Battler
		def hp_cost(item,target)
			temp = target.hp_cost
			cs_hp_cost_sum(item,target) {|i| temp += i}
			cs_hp_cost_multi(item,target) {|i| temp *= i}if temp > 0
			cs_hp_cost_add(item,target) {|i| temp += i}if temp > 0
			return temp
		end
		def mp_cost(item,target)
			temp = target.mp_cost
			cs_mp_cost_sum(item,target) {|i| temp += i}
			cs_mp_cost_multi(item,target) {|i| temp *= i}if temp > 0
			cs_mp_cost_add(item,target) {|i| temp += i}if temp > 0
			return temp
		end
		
		private
		def hpmp_cs_can_use_all(item,target)#:nodoc:
			return hp_cost(item,target) <= self.hp && mp_cost(item,target) <= self.mp
		end
	end
end
