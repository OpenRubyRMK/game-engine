require_relative "enemy"
require_relative "proxy"
require_relative "element"
module RPG
	class Enemy
		attr_proxy :elements
		private
		def element_cs_init#:nodoc:
			@elements=Proxy.new(Hash.new(1.0),Element,Float) #element => resistances
		end
	end
end
module Game
	class Enemy
		
		def elements
			return data.elements
		end
	end
end