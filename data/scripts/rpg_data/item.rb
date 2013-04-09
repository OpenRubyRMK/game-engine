require "baseitem"
require "usableitem"
module RPG
	class Item < BaseItem
		include UsableItem	
		class << self
			def each(&block)
				superclass.find_all{|i| i.is_a?(self)}.each(&block)
			end
			def [](id)
				return nil if id.nil?
				return superclass.find_all{|i| i.is_a?(self)}[id]
			end
		end
	end
end
class Game::Item < Game::BaseItem
		#insert targets
end