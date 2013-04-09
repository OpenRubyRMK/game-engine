require_relative "draw"
require_relative "actoractorclass"

module RPG
	class Skill
		attr_proxy :draw_actorclass
		private
		def drawclass_cs_init#:nodoc:
			@draw_actorclass = Proxy.new({},ActorClass,Integer)
		end
	end
end

module Game
	class Actor
		private
		def drawactorclass_cs_could_draw(skill)#:nodoc:
			skill.draw_actorclass.each do |ac,n|
				return false unless self.actorclass.include?(ac) && self.actorclass[ac].level >= n
			end
			return true
		end
	end
end