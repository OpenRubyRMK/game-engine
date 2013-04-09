require_relative "csmod"
module Game
	class Battler
		attr_reader :name
		attr_reader :hp,:mp
		def initialize(name)
			@name = name
			@hp = maxhp
			@mp = maxmp
			cs_init_before
			cs_init
			cs_init_after
		end
		def to_sym
			return @name
		end
		def rpg
			raise NotImplementedError
		end
		def basehp
			raise NotImplementedError
		end
		def basemp
			raise NotImplementedError
		end
		def atk
			return stat(:atk,rpg.atk)
		end
		def spi
			return stat(:spi,rpg.spi)
		end
		def def
			return stat(:def,rpg.def)
		end
		def agi
			return stat(:agi,rpg.agi)
		end
		def maxhp
			return stat(:hp,basehp)
		end
		def maxmp
			return stat(:mp,basemp)
		end
		
		def hp=(value)
			old = @hp
			@hp = [[value, maxhp].min, 0].max
			cs_stat_change(:hp,old)
		end
		
		def mp=(value)
			old = @mp
			@mp = [[value, maxmp].min, 0].max
			cs_stat_change(:mp,old)
		end
		
		private
		def stat(key,default=0)
			temp = cs_stat_multi(key).inject(default,:*)
			return cs_stat_add(key).inject(temp,:+)
		end
	end
end
