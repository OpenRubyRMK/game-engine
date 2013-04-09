require_relative "state"

module RPG
	class State
		attr_accessor :atk_rate,:def_rate,:spi_rate,:agi_rate
		private
		def stats_cs_init#:nodoc:
			@atk_rate=1
			@def_rate=1
			@spi_rate=1
			@agi_rate=1
		end
	end
end
module Game
	class State

		def atk_rate
			return data.atk_rate
		end
		
		def def_rate
			return data.def_rate
		end
		
		def agi_rate
			return data.agi_rate
		end
		
		def spi_rate
			return data.spi_rate
		end
	end
end