require "battlerskills"
require "actoractorclass"
require "usableitem"

module RPG
	module UsableItem
		def learn_skills
			@learn_skills = Proxy.new({},ActorClass,Proxy.new({},Integer,Proxy.new([],Skill))) if @learn_skills.nil?
			return @learn_skills
		end
		def learn_skills=(value)
			learn_skills.replace(value)
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
		def usablelearnskills_cs_item_use(user,item)
			item.data.learn_skills.each do |ac,pr|
				if actorclass.include?(ac)
					pr.each do |l,askill|
						askill.each {|skill| @usablelearnskills[ac][skill] = skill.newGameObj } if l <= actorclass[ac].level
					end
				end
			end
		end
	end
end