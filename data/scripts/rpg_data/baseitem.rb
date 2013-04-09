require_relative "csmod"
require_relative "rpgclasses"
require_relative "gameclasses"
require_relative "translation"
module RPG
	class BaseItem
		include RPG::RPGClasses
		attr_accessor :price
	
		translation :name,:description
		
		def initialize
			@price=0
			cs_init
			BaseItem.instances.push(self)
		end
		
		def icon
		end

		def ===(item)#game::item
			return self == item.data
		end
		
		def newGameObj
			return Game.const_get(self.class.name.split("::").last).new(self)
		end
		

	end
end

module Game
	class BaseItem
		include Game::GameClasses
		def initialize(item)
			self.data = item
			#cs for the modules
			Game.constants.find_all do |s|
				RPG.const_defined?(s) && data.is_a?(RPG.const_get(s))
			end.map do |s|
				Game.const_get(s)
			end.each do |s|
				self.extend(s) if s.instance_of?(Module)
			end
			cs_init
		end
		def name
			return data.name
		end
		def description
			return data.description
		end
		def price
			temp = data.price
			cs_stat_multi(:price) {|i| temp *= i}
			cs_stat_add(:price) {|i| temp += i}
			return temp
		end
		
		def icon
			return data.icon
		end
	end
end