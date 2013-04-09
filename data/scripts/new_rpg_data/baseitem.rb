require_relative "baseobject"
module RPG
	class BaseItem < BaseObject
		
		attr_accessor :price
	
		#translation :name,:description
		
		def initialize(name)
			@price=0
			super
		end
		
	end
end

module Game
	class BaseItem
		attr_reader :name
		def initialize(name)
			@name = name
			#get the Game Modules of the curresponding RPG Modules
			Game.constants.each do |s|
				if RPG.const_defined?(s) && rpg.is_a?(RPG.const_get(s)) &&
					 Game.const_get(s).instance_of?(Module)
					self.extend(Game.const_get(s))
				end
			end
			cs_init
		end
		def to_sym
			return @name
		end
		def rpg
			return RPG::BaseItem[@name]
		end
		def price
			return stat(:price,rpg.price)
		end
		private
		def stat(key,default=0,type=nil)
			temp = cs_stat_sum(key,type).inject(default,:+)
			temp = cs_stat_multi(key,type).inject(temp,:*)
			temp = cs_stat_add(key,type).inject(temp,:+)
			return temp
		end
	end
end
