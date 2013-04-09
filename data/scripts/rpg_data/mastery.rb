require_relative "csmod"
require_relative "element"
require_relative "levelble"
module RPG
	class Mastery
		include RPG::RPGClasses
		include RPG::Levelble
		attr_writer :icon
		attr_rpg(:element,RPG::Element)
		translation :name
		def icon
			return @icon.nil? ? element.nil? ? nil : element.icon : @icon
 		end
		
	end
end

module Game
	class Mastery
		include Game::Levelble
		include Game::GameClasses
		def initialize(item)
			self.data = item
			cs_init
		end
		def icon
			return @data.icon
		end
		def name
			return @data.name
		end
	end
end