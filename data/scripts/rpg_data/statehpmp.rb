require_relative "targethpmp"
require_relative "battlerstate"

module RPG
	class State
	##
	# :attr_accessor: hp_cost_multi mp_cost_multi
		
		attr_proxy :hp_cost_multi,:mp_cost_multi
		attr_accessor :mp_to_hp_cost
		private
		def mphp_cs_init#:nodoc:
			@hp_cost_multi = Proxy.new(Hash.new(1),Skill,Float)
			@mp_cost_multi = Proxy.new(Hash.new(1),Skill,Float)
			@mp_to_hp_cost = false
		end
	end
end
module Game
	class Battler
		private
		#:stopdoc:
		def state_cs_hp_cost_sum(item,target)
			reutrn self.states.keys.any?{|state|state.mp_to_hp_cost} ? target.mp_cost : 0
		end
		def state_cs_hp_cost_multi(item,target)
			temp = 1
			case item
			when RPG::Skill
				self.states.each_key{|state| temp *= state.hp_cost_multi(item)}
			when Game::Skill
				temp *= state_cs_hp_cost_multi(item.data)
			end
			return temp
		end

		def state_cs_mp_cost_multi(item,target)
			return 0 if self.states.keys.any?{|state|state.mp_to_hp_cost}
			temp = 1
			case item
			when RPG::Skill
				self.states.each_key{|state| temp *= state.mp_cost_multi(item)}
			when Game::Skill
				temp *= state_cs_mp_cost_multi(item.data)
			end
			return temp
		end
		#:startdoc:
	end
end