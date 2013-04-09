require_relative "usablebattlerstate"
require_relative "levelbleskill"

module RPG
	class Skill
		attr_proxy :add_states_lvl,:del_states_lvl
		private
		def statelevelble_cs_init#:nodoc:
			#{level => {RPG::State => rate} }
			@add_states_lvl = Proxy.new(Hash,Integer,Proxy.new(Hash.new(0),RPG::State,Float))
			@del_states_lvl = Proxy.new(Hash,Integer,Proxy.new(Hash.new(0),RPG::State,Float))
		end
	end
end
module Game
	class Skill
		# erst summieren, dann multiplizieren, dann addieren
		private
		def statelevelble_cs_add_states_sum#:nodoc:
			return hash.new(0) if @level.nil?
			return self.data.add_states_lvl[@level]
		end
		def statelevelble_cs_del_states_sum#:nodoc:
			return hash.new(0) if @level.nil?
			return self.data.del_states_lvl[@level]
		end
	end
end
