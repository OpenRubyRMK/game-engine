require "equipableitem"
require "state"
require "equipment"
module RPG
	module EquipableItem
		def def_states_multi
			@def_states_multi = Proxy.new(Hash.new(1),State,Float) if @def_states_multi.nil?
			return @def_states_multi
		end
		def def_states_multi=(value)
			def_states_multi.replace(value)
			return value
		end
		def def_states_add
			@def_states_add = Proxy.new(Hash.new(0),State,Float) if @def_states_add.nil?
			return @def_states_add
		end
		def def_states_add=(value)
			def_states_add.replace(value)
			return value
		end
		def autostates
			@autostates =Proxy.new([],State) if @autostates.nil?
			return @autostates
		end
		def autostates=(value)
			autostates.replace(value)
			return value
		end
	end
end
module Game
	module EquipableItem
		attr_reader :autostates
		private
		def autostates_cs_init
			@autostates=Proxy.new({},RPG::State,Game::State)
			self.data.autostates.each {|state| @autostates[state]=state.newGameObj}
		end
	end
	class Equipment
		def states
			result = Hash.new([])
			cs_states.each {|hash| hash.each{|k,v| result[k]+=v}}
			return result
		end
		private
		def autostates_cs_states
			temp = Proxy.new([],Game::State)
			temp.max_size = 1
			result = Proxy.new({},RPG::State,temp)
			self.items.each {|item| item.autostates.each {|rstate,gstate| result[rstate] +=[gstate] }}
			return result
		end
		def def_states_cs_states_multi(state)
			result = 1
			self.items.each {|item| result *= item.data.def_states_multi[state]}
			return result
		end
		def def_states_cs_states_add(state)
			result = 0
			self.items.each {|item| result += item.data.def_states_add[state]}
			return result
		end
	end
end