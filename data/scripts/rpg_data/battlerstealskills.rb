# require "item"
# require "skill"
# require "battlerskills"
# require "proxy"
# module RPG
# 	module UsableItem
# 		def steal_skills
# 			@steal_skills = Proxy.new([],RPG::Skill) if @steal_skills.nil?
# 			return @steal_skills
# 		end
# 		def steal_skills=(value)
# 			steal_skills.replace(value)
# 			return value
# 		end
# 	end
# end
# 
# module Game
# 	class Battler
# 		def add_stolen_skill(skill)
# 			return false if @steal_get_skills.include?(skill.data)
# 			@steal_get_skills[skill.data] +=[skill]
# 			return true
# 		end
# 		private
# 		def stealskills_cs_init
# 			@steal_lose_skills = Proxy.new([],RPG::Skill)
# 			@steal_get_skills = Proxy.new({},RPG::Skill,Game::Skill)
# 		end
# 		
# 		def stealskills_cs_use(user,item)
# 			item.data.steal_skills.each do |s|
# 				if skills.include?(s) && user.add_stolen_skill(skills[s].first)
# 					@steal_lose_skills.push(s)
# 					cs_stealskill(s)
# 				end
# 			end
# # 		end
# # 		def stealskills_cs_skill_use(user,skill)
# # 			skill.data.steal_skills.each do |s|
# # 				if skills.include?(s) && user.add_stolen_skill(skills[s].first)
# # 					@steal_lose_skills.push(s)
# # 					cs_stealskill(s)
# # 				end
# # 			end
# # 		end
# 		
# 		def stealskills_cs_skills
# 			result = Hash.new([])
# 			@steal_get_skills.each {|rskill,gskills| result[rskill] +=[gskills]}
# 			return result
# 		end
# 
# 		def stealskills_cs_can_use_all(skill)
# 			case skill
# 			when RPG::Skill
# 				return false if @steal_lose_skills.include?(skill)
# 			when Game::Skill
# 				return false if @steal_lose_skills.include?(skill.data)
# 			end
# 			return true
# 		end
# 
# 		def stealskills_cs_can_use_any(skill)
# 			case skill
# 			when RPG::Skill
# 				return @steal_get_skills.include?(skill)
# 			when Game::Skill
# 				return @steal_get_skills[skill.data] == skill
# 			end
# 			return false
# 		end
# 	end
# end
