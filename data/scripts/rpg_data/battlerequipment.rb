require_relative "equipment"
require_relative "battler"
class Game::Battler
	attr_reader :equipment
	private
	def equip_cs_init#:nodoc:
		if data.equipment
			@equipment = Game::Equipment.new(data.equipment,self)
		end
	end
	def equip_cs_stats_add(stat)#:nodoc:
		return @equipment ? @equipment.stats(stat) : 0
	end
	def equip_cs_skills#:nodoc:
		return @equipment ? @equipment.skills : Hash.new([])
	end
	def equip_cs_states#:nodoc:
		return @equipment ? @equipment.states : Hash.new([])
	end
	def equip_cs_states_rate_multi(state)#:nodoc:
		temp = 1
		@equipment.cs_states_rate_multi(state) {|i| temp*=i} if @equipment.nil?
		return temp
	end
	def equip_cs_can_use_any(skill)#:nodoc:
		return @equipment ? @equipment.cs_can_use_any(skill).any? : false
	end
end