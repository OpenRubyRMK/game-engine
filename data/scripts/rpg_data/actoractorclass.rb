require_relative "actor"
require_relative "actorclass"
require_relative "proxy"

module RPG
	class Actor
		attr_proxy :actorclass
		private
		def actorclass_cs_init#:nodoc:
			@actorclass = Proxy.new([],ActorClass) if @actorclass.nil?
			return @actorclass
		end
	end
end

module Game
	class Actor < Battler
		attr_proxy :actorclass
		def disable_actorclass(rclass)
			return if !@actorclass.include?(rclass) || @disabled_actorclass.include?(rclass)
			@disabled_actorclass[rclass] = @actorclass[rclass]
			@actorclass.delete(rclass)
			return self
		end
		
		def enable_actorclass(rclass)
			return if @actorclass.include?(rclass) || !@disabled_actorclass.include?(rclass)
			if @disabled_actorclass.include?(rclass)
				@actorclass[rclass] = @disabled_actorclass[rclass]
				@disabled_actorclass.delete(rclass)
			else
				@actorclass[rclass] = ActorClass.new(ac)
				cs_add_actorclass(rclass)
			end
			return self
		end
		
		private
		def actorclass_cs_init#:nodoc:
			@actorclass = Proxy.new({},RPG::ActorClass,Game::ActorClass)
			@disabled_actorclass = Proxy.new({},RPG::ActorClass,Game::ActorClass)
			self.data.actorclass.each do |ac|
				@actorclass[ac]=ActorClass.new(ac)
				cs_add_actorclass(ac)
			end
		end
		def actorclass_cs_levelup(level)#:nodoc:
			@actorclass.each_values {|ac| ac.upgrade}
		end
		
	end
end