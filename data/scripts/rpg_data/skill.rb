require_relative "baseitem"
require_relative "usableitem"
module RPG
class Skill < BaseItem
	include RPG::UsableItem
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
module Game
	class Skill < BaseItem
			#insert targets
	end
end