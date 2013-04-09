require "battlerstate"
require "usableitem"

module RPG
	module UsableItem
		def add_states
			@add_states = Proxy.new({},State,Float) if @add_states.nil?
			return @add_states
		end
		def add_states=(value)
			add_states.replace(value)
			return value
		end
		def del_states
			@del_states = Proxy.new({},State,Float) if @del_states.nil?
			return @del_states
		end
		def del_states=(value)
			del_states.replace(value)
			return value
		end
	end
end
module Game
	module UsableItem
		def add_states
			hash = Hash.new(1)
			cs_add_states {|h| h.each {|s,f| hash[s] *=f }}
			return hash
		end
	
		def del_states
			hash = Hash.new(1)
			cs_del_states {|h| h.each {|s,f| hash[s] *=f }}
			return hash
		end
		
		private
		def default_cs_add_states
			return self.data.add_states
		end
		def default_cs_del_states
			return self.data.del_states
		end
	end
	class Battler
		private
# 		def state_cs_use(user,item)
# 			if !item.add_states.empty?
# 				item.add_states.each do |state,rate|
# 					temp = rate
# 					cs_states_rate_multi(state) {|i| temp*=i}
# 					cs_states_rate_add(state) {|i| temp+=i}
# 					return add_state(state) if rand() <= temp
# 				end
# 			end
# 			if !item.del_states.empty?
# 				item.del_states.each do |state,rate|
# 					temp = rate
# 					cs_states_rate_multi(state) {|i| temp*=i}
# 					cs_states_rate_add(state) {|i| temp+=i}
# 					return remove_state(state) if rand() <= temp
# 				end
# 			end
# 		end
	end
end
