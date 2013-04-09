require_relative "actor"
require_relative "battlerelement"
class RPG::ActorClass
	##
	# :attr_accessor: elements
	
	attr_proxy :elements
	private
	def elements_cs_init#:nodoc:
		@elements=Proxy.new({},RPG::Element,1) #element => resistances
	end
end
class Game::Actor
	private
	def actor_cs_elements_multi#:nodoc:
		result = Hash.new(1)
		actorclass.each_keys {|ac| ac.elements.each {|el,v| result[el] *=v}}
		return result
	end
end