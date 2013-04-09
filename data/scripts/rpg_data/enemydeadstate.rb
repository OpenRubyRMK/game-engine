require "enemyhpmp"
require "battlerdeadstate"
module RPG
	class Enemy
		attr_rpg :dead_state, State
	end
end