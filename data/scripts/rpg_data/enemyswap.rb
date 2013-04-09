require_relative "enemy"
require_relative "proxy"

module RPG
	class Enemy
		attr_proxy :swap_enemies
		private
		def swap_cs_init#:nodoc:
			@swap_enemies = Proxy.new([],Enemy)
		end
	end
end

module Game
	class Enemy
		private
		def swap_cs_init_post#:nodoc:
			self.data = self.data.swap_enemies.sample unless self.data.swap_enemies.empty?
		end
	end
end
