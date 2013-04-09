require "target"
require "actorjp"
module RPG
	class Target
		attr_accessor :jp_gain_any,:jp_gain_ally,:jp_gain_enemy,:jp_gain_user
		
		private
		def jp_cs_init
			@jp_gain_any = 0
			@jp_gain_ally = 0
			@jp_gain_enemy = 0
			@jp_gain_user = 0
		end
	end
end

module Game
	class Actor
		private
		def jp_cs_use(user,item,target,key)
			return unless target.respond_to?("jp_gain_#{key}")
			jp_gain(target.send("jp_gain_#{key}"))
		end
	end
end