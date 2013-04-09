require_relative "battler"
require_relative "usableitem"

module Game
	class Battler
		def usable?(item)
			return cs_usable(item).all?
		end
	end
end