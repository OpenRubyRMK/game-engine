require "baseitem"
require "equipableitem"
module RPG
	class Weapon < BaseItem
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
		
		def initialize
			super
			@hands=1
		end
		attr_accessor :hands
	end
end
class Game::Weapon < Game::BaseItem
	
	#insert Targets
	
	def hands
		return @data.hands
	end
end