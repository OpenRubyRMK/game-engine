require_relative "rpgclasses"
require_relative "gameclasses"
require_relative "csmod"
require_relative "proxy"

module RPG
	class State
		include RPGClasses
		translation :name
		attr_proxy :states_cancel
		attr_accessor :priority
		attr_accessor :noexp,:noevade,:battle_only
		attr_accessor :hold_turn,:auto_release_prob,:stocks
		def initialize(name)
			@name=name

			@priority = 5
			@noexp=false
			@noevade = false
			@battle_only = true
			@states_cancel = Proxy.new([],State)
			@hold_turn=0
			@auto_release_prob = 0.0
			@stocks=0
			cs_init
			State.instances.push(self)
		end
		def icon
		end
	end
end

module Game
	class State
		include GameClasses
		attr_accessor :turns
		def initialize(state)
			self.data=state
			cs_init
			@turns = data.hold_turn
		end

		def states_cancel
			return data.states_cancel
		end
		def auto_release_prob
			return data.auto_release_prob
		end
	end
end