require_relative "enemy"
require_relative "battlerstate"

module RPG
	class Enemy
		attr_proxy :autostates
		private
		def autostates_cs_init#:nodoc:
			@autostates = Proxy.new([],State)
		end
	end
end
module Game
	class Enemy
		private
		def autostates_cs_init#:nodoc:
			@autostates =  Proxy.new({},RPG::State,Game::State)
			self.data.autostates.each {|state| @autostates[state]=State.new(state) }
		end
		def autostates_cs_states#:nodoc:
			result = Hash.new([])
			@autostates.each {|rstat,gstats| result[rstat] = [gstats] }
			return result
		end
	end
end