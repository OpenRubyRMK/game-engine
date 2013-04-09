require "soulpiece"
require "actoractorclass"

module RPG
	class ActorClass
		
	end
end

module Game
	class Actor
		attr_reader :soulpieces
		
		def soulpieces=(value)
			@soulpieces.replace(value)
		end
		private
		def soulpiece_cs_init
			@soulpieces = Proxy.new(Hash.new(0),RPG::SoulPiece,Integer)
		end
	end
end