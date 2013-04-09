require "target"
require "enemy"

module RPG
	class Target
		attr_proxy :include_enemies,:exclude_enemies
		private
		def enemy_cs_init
			@include_enemies = Proxy.new([],RPG::Enemy)
			@exclude_enemies = Proxy.new([],RPG::Enemy)
		end
	end
end

module Game
	class Enemy
		private
		def enemy_can_target(user,item,target,key)
			return target.include_enemies.any?{|i|i==self.data} || target.exclude_enemies.none?{|i|i==self.data}
		end
	end
end