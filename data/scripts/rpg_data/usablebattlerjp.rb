require "actorjp"
require "usableitem"
require "battler"
module RPG
	module UsableItem
		attr_writer :jp_gain
		def jp_gain
			@jp_gain = 0 if @jp_gain.nil?
			return @jp_gain
		end
	end
end
module Game
	class Battler
		private
		def jp_cs_use(user,item)
			user.gain_jp(item.data.jp_gain) if user.is_a?(Game::Actor)
		end
	end
end