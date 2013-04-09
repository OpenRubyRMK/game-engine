require_relative "abilityskill"
module RPG
	class Skill
		attr_proxy :blue_magic
		private
		def blue_magic_cs_init#:nodoc:
			@blue_magic = Proxy.new({},Ability,Proxy.new(Hash.new(0),Integer,Float))
		end
	end
	class Ability
		attr_accessor :blue_magic_user_learn
	end
end
module Game
	class Skill
		def blue_magic
			return self.data.blue_magic
		end
	end
	class Battler
		private
		def blue_magic_cs_init#:nodoc:
			@blue_magic =Proxy.new({},RPG::Skill,Game::Skill)
		end
		def blue_magic_cs_can_use_any(skill)#:nodoc:
			case skill
			when RPG::Skill
				return true if @blue_magic.include?(skill)
				return skill.blue_magic.any? {|atri,hash| abilities.include?(atri) && abilities[atri].blue_magic.include?(skill) }
			when Game::Skill
				return true if @blue_magic[skill.data] == skill
				return skill.blue_magic.any? {|atri,hash| abilities.include?(atri) && abilities[atri].blue_magic[skill.data] == skill }
			end
			return false
		end
		def blue_magic_cs_skills#:nodoc:
			result = Hash.new([])
			@blue_magic.each {|rskill,gskill| result[rskill] +=[gskill] }
			return result
		end
		def blue_magic_cs_use(user,skill)#:nodoc:
			if skill.is_a?(Game::Skill) && !@blue_magic.include?(skill.data)
				skill.data.blue_magic.each do |atri,hash|
					next unless abilities.include?(atri)
					temp = hash[abilities[atri].level]
					cs_blue_magic_multi(skill,abilities[atri]) {|i| temp*=i}
					return if temp == 0
					cs_blue_magic_add(skill,abilities[atri]) {|i| temp+=i}
					if temp >= rand
						(atri.blue_magic_user_learn ? @blue_magic : abilities[atri].blue_magic)[skill.data] = skill#.data.newGameObj
						cs_blue_magic_learned(skill.data)
					end
				end
			end
		end
	end
	class Ability
		attr_proxy :blue_magic
		private
		def blue_magic_cs_init#:nodoc:
			@blue_magic =Proxy.new({},RPG::Skill,Game::Skill)
		end
		def blue_magic_cs_skills#:nodoc:
			result = Hash.new([])
			@blue_magic.each {|rskill,gskill| result[rskill] +=[gskill] }
			return result
		end
	end
end