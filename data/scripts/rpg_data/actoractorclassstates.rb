require_relative "actoractorclass"
require_relative "state"
module RPG
	class ActorClass
		attr_proxy :def_states_multi,:def_states_add
		private
		def def_states_cs_init#:nodoc:
			@def_states_multi = Proxy.new(Hash.new(1),State,Float)
			@def_states_add = Proxy.new(Hash.new(0),State,Float) 
		end
	end
end

module Game
	class Actor
		private
		def actorclass_cs_states_multi(state)#:nodoc:
			temp = 1
			self.actorclass.each_values {|gac| temp *= gac.data.def_states_multi[state]}
			return temp
		end
		def actorclass_cs_states_add(state)#:nodoc:
			temp = 0
			self.actorclass.each_values {|gac| temp += gac.data.def_states_multi[state]}
			return temp
		end
	end
end