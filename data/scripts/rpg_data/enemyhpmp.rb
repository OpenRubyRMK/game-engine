require_relative "enemy"
require_relative "battlerhpmp"
module RPG
	class Enemy
		attr_accessor :hp,:mp
		private
		def hpmp_cs_init#:nodoc:
			@hp=0
			@mp=0
		end
	end
end
module Game
	class Actor
		def basehp
			return self.data.hp
		end
		def basemp
			return self.data.mp
		end
	end
end