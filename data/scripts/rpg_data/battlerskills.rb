require_relative "battler"
require_relative "skill"

class Game::Battler
	
	def skills
		result = Hash.new([])
		cs_skills.each {|hash| hash.each{|k,v| result[k]+=v}}
		return result
	end
	def can_use?(skill)
		return false unless cs_can_use_all(skill).all?
		result = cs_can_use_any(skill)
		return result.empty? || result.any?
	end
end