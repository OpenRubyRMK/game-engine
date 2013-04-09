require "baseitem"
require "battlerequipment"
require "mastery"
require "skill"
module RPG
	class Mastery
		attr_accessor :atk_rate,:def_rate,:spi_rate,:agi_rate
		
		def items
			@items = Proxy.new([],BaseItem) if @items.nil?
			return @items
		end
		def items=(value)
			items.replace(value)
		end
		def skills
			@skills = Proxy.new({},Integer,Proxy.new([],Skill)) if @skill.nil? #{level => [skill]}
			return @skills
		end
		def skills=(value)
			skills.replace(value)
		end
		
	end
end

module Game
	class Mastery
		attr_reader :skills
		
		def skills=(value)
			@skills.replace(value)
		end
		
		def atk_rate
			case self.data.atk_rate
			when Hash
				return self.data.atk_rate[level]
			when Numerable
				return self.data.atk_rate * level
			else
				return 1
			end
		end
		def def_rate
			case self.data.def_rate
			when Hash
				return self.data.def_rate[level]
			when Numerable
				return self.data.def_rate * level
			else
				return 1
			end
		end
		def spi_rate
			case self.data.spi_rate
			when Hash
				return self.data.spi_rate[level]
			when Numerable
				return self.data.spi_rate * level
			else
				return 1
			end
		end
		def agi_rate
			case self.data.agi_rate
			when Hash
				return self.data.agi_rate[level]
			when Numerable
				return self.data.agi_rate * level
			else
				return 1
			end
		end
		private
		def skills_cs_init
			@skills = Proxy.new({},RPG::Skill,Game::Skill)
		end
		def skills_cs_levelup(l)
			self.data.skills[l].each{|skill| @skills[skill]=skill.newGameObj}
		end
	end
	class Equipment
		private
		def mastery_cs_stats_item_multi(stat,key,item)
			return 1 unless self.actor.respond_to?(:mastery)
			result = 1
			self.actor.mastery.values.find_all {|mastery| mastery.items.include?(item.data) }.each do |mastery|
				result *= mastery.respond_to?("#{stat}_rate") ? mastery.send("#{stat}_rate") : 1
			end
			return result
		end
		def mastery_cs_skills
			return {} unless self.actor.respond_to?(:mastery)
			result = Hash.new([])
			self.actor.mastery.each_value do |mastery| 
				mastery.skills.each {|rskill,gskill| result[rskill] +=[gskill] } if items.any? { |item| mastery.data.items.include?(item.data)}
			end
		end
		def mastery_cs_can_use_any(skill)
			return false unless self.actor.respond_to?(:mastery)
			return self.actor.mastery.any? do |*,mastery|
				items.any? { |item| mastery.data.items.include?(item.data)} && case skill
				when RPG::Skill
					mastery.skills.include?(skill)
				when Game::Skill
					mastery.skills[skill.data] == skill
				else
					false
				end
			end
		end
	end
end