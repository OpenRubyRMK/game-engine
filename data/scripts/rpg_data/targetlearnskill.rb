require "battlerskills"
require "actoractorclass"
require "target"

module RPG
	class Target
		attr_proxy :learnskills_any,:learnskills_ally,:learnskills_enemy,:learnskills_user
		private
		def learnskills_cs_init
			@learnskills_any = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Skill)))
			@learnskills_ally = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Skill)))
			@learnskills_enemy = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Skill)))
			@learnskills_user = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Skill)))
		end
	end
end

module Game
	class Actor
		private
		def usablelearnskills_cs_init
			@usablelearnskills = Proxy.new({},RPG::ActorClass,Proxy.new({},RPG::Skill,Game::Skill))
		end
		def usablelearnskills_cs_skills
			result = Hash.new([])
			@usablelearnskills.each_value {|pr| pr.each {|rskill,gskill| result[rskill]+= [gskill] }}
			return result
		end
		def usablelearnskills_cs_can_use_any(skill)
			case skill
			when RPG::Skill
				return actorclass.keys.any? { |ac| @usablelearnskills[ac].include?(skill)}
			when Game::Skill
				return actorclass.keys.any? { |ac| @usablelearnskills[ac][skill.data] == skill}
			end
			return false
		end
		def usablelearnskills_cs_use(user,item,target,key)
			return unless target.respond_to?("learnskills_#{key}")
			target.send("learnskills_#{key}").each do |ac,pr|
				if actorclass.include?(ac)
					pr.each do |l,askill|
						askill.each {|skill| @usablelearnskills[ac][skill] = skill.newGameObj } if l <= actorclass[ac].level
					end
				end
			end
		end
	end
end