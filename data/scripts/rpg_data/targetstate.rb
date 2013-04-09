require "target"
require "battlerstate"

module RPG
	class Target
		attr_proxy :add_states_any,:add_states_ally,:add_states_enemy,:add_states_user
		attr_proxy :del_states_any,:del_states_ally,:del_states_enemy,:del_states_user
		
		attr_proxy :include_states,:exclude_states
		private
		def state_cs_init
			@add_states_any = Proxy.new(Hash.new(0),State,Float)
			@add_states_ally = Proxy.new(Hash.new(0),State,Float)
			@add_states_enemy = Proxy.new(Hash.new(0),State,Float)
			@add_states_user = Proxy.new(Hash.new(0),State,Float)
			
			@del_states_any = Proxy.new(Hash.new(0),State,Float)
			@del_states_ally = Proxy.new(Hash.new(0),State,Float)
			@del_states_enemy = Proxy.new(Hash.new(0),State,Float)
			@del_states_user = Proxy.new(Hash.new(0),State,Float)
			
			@include_states = Proxy.new([],State)
			@exclude_states = Proxy.new([],State)
		end
	end
end

module Game
	class Battler
		private
		def state_cs_use(user,item,target,key)
			return unless target.respond_to?("add_states_#{key}")
			target.send("add_states_#{key}").each do |state,rate|
				temp = rate
				cs_states_defense_add_multi(state) {|i| temp*=i}
				user.cs_states_attack_add_multi(state) {|i| temp*=i}
				cs_states_defense_add_add(state) {|i| temp+=i}
				user.cs_states_attack_add_add(state) {|i| temp+=i}
				add_state(state) if rand() <= temp
			end
			return unless target.respond_to?("del_states_#{key}")
			target.send("del_states_#{key}").each do |state,rate|
				temp = rate
				cs_states_defense_del_multi(state) {|i| temp*=i}
				user.cs_states_attack_del_multi(state) {|i| temp*=i}
				cs_states_defense_del_add(state) {|i| temp+=i}
				user.cs_states_attack_del_add(state) {|i| temp+=i}
				remove_state(state) if rand() <= temp
			end
		end
		def state_can_target(user,item,target,key)
			#return true if key==:all
			return self.states.keys.all? {|s| target.include_states.any?{|i|i==s} || target.exclude_states.none?{|i|i==s}}
		end
	end
end