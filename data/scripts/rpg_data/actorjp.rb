require_relative "actoractorclass"
module RPG
	class ActorClass
		attr_accessor :jp_get,:jp_max
		private
		def jp_cs_init#:nodoc:
			@jp_get = 0
			@jp_max = 9999999
		end
	end
end
module Game
	class Actor
		attr_proxy :jp
		
		def earn_jp(value)
			temp = value
			cs_earn_jp_multi {|i| i *= temp}
			cs_earn_jp_add {|i| i += temp}
			jp += temp
		end
		def lose_jp(value)
			jp -= value
		end
		def jp_can_learn?(obj)
			return cs_jp_can_learn(obj).all?
		end
		def jp_learn(obj)
			return unless jp_can_learn?(obj)
			cs_jp_learn(obj)
		end
		private
		def jp_cs_init#:nodoc:
			max = self.actorclass.keys.map {|ac| ac.j_max}.max
			@jp = Proxy.new(0,0,max)
		end
		def jp_cs_levelup(level)#:nodoc:
			self.actorclass.each_key {|ac| earn_jp(ac.jp_get) }
		end
		def cost_jp_learn(obj)#:nodoc:
			lose_jp(obj.jp_cost)
		end
		def cost_jp_can_learn(obj)#:nodoc:
			return obj.jp_cost <= jp
		end
		def actorclass_jp_can_learn(obj)#:nodoc:
			return obj.jp_require_actorclass.map { |ac,n| self.actorclass.include?(ac) && self.actorclass[ac].level >= n }.all?
		end
	end
end