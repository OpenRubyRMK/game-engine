require_relative "actor"
require_relative "battlerhpmp"
module RPG
	class Actor
		attr_accessor :hp,:mp
		private
		def hp_cs_set_max_level(value)#:nodoc:
			return @hp
		end
		def mp_cs_set_max_level(value)#:nodoc:
			return @hp
		end
		def hpmp_cs_init#:nodoc:
			#{level => value}
			@hp = {}
			@mp = {}
		end
	end
end
module Game
	class Actor
		def basehp
			return self.data.hp[self.level]
		end
		def basemp
			return self.data.mp[self.level]
		end
	end
end