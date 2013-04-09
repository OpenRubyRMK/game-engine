require_relative "state"
require_relative "element"


module RPG
	class State
		attr_proxy :elements,:resistances,:add_elements,:del_elements
		private
		def elements_cs_init#:nodoc:
			@elements=Proxy.new(Hash.new(0),Element,Float) #element => resistances -> for attack
			@resistances=Proxy.new(Hash.new(0),Element,Float) #element => resistances -> for defense
			@add_elements =Proxy.new([],Element)
			@del_elements =Proxy.new([],Element)
		end
	end
end
module Game
	class State
		def elements
			return data.elements
		end
		def resistances
			return data.resistances
		end
		def add_elements
			return data.add_elements
		end
		def del_elements
			return data.del_elements
		end
	end
end