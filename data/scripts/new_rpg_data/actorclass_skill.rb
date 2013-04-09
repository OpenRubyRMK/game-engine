require_relative "actorclass"
require_relative "battler_skill"

module RPG
	class ActorClass
		attr_accessor :skills
		
		private
		def skills_cs_init
			@skills = Hash.new([]) #level => [key]
		end
		
		def skills_cs_to_xml(xml)
			xml.skills {
				@skills.each{|k,o|
					o.each {|v|
						xml.skill(:name=>v,:level=>k)
					}
				}
			}
		end
		def skills_cs_parse(actorclass)
			actorclass.xpath("skills/skill").each {|sk|
				@skills[sk["level"].to_i]+=[sk["name"].to_sym]
				Skill.parse_xml(sk) unless sk.children.empty?
			}
		end
	end
end

module Game
	class Actor
		private
		def actorclass_cs_skills
			result = Hash.new([])
			actorclasses.each_value {|ac|
				ac.skills.each{|n,s| result[n] += s }
			}
			return result
		end
	end
	class ActorClass
		attr_reader :skills
		private
		def skills_cs_init
			@skills = Hash.new([])
		end
		def skills_cs_levelup
			rpg.skills[@level].each{|n|
				@skills[n] += [Skill.new(n)]
				cs_skill_learned(n)
			}
		end
	end
end
