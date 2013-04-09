require "equipment"
class RPG::Equipment
	attr_accessor :offhand_malus,:barehand_boost,:hands
	private
	def hand_cs_init
		@offhand_malus = 0
		@barehand_boost = 0
		@hands = []#array of symbols
	end
end

class Game::Equipment
	
	def hand_items
		return self.data.hands.map {|key| @sockets[key].item}.compact
	end
	def free_hands
		return self.data.hands.count {|key| @sockets[key].item.nil?}
	end
	
end