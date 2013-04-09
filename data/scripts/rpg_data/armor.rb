require "baseitem"
require "equipableitem"
module RPG
	class Armor < BaseItem
		include EquipableItem
		
		class << self
			def each(&block)
				superclass.find_all{|i| i.is_a?(self)}.each(&block)
			end
			def [](id)
				return nil if id.nil?
				return superclass.find_all{|i| i.is_a?(self)}[id]
			end
		end
		#include SockableItem
	end
end
class Game::Armor < Game::BaseItem
end