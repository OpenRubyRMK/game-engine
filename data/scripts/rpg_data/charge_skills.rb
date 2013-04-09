require "battlerequipment"
require "equipableitem"
require "skill"
module RPG
	module Equipableitem
		def charge_skills
			@charge_skills = Proxy.new({},Skill,Integer) if @charge_skills.nil?
			return @charge_skills
		end
		def charge_skills=(value)
			charge_skills.replace(value)
		end
	end
	class Skill
		attr_accessor :charge_empty_price
		private
		def charge_cs_init#:nodoc:
			@charge_empty_price = 0
		end
	end
end

module Game
	module ChargeSkill
		attr_accessor :charges
	end
	module EquipableItem
		attr_reader :charge_skills
		private
		def charge_cs_init#:nodoc:
			@charge_skills = Proxy.new({},RPG::Skill,Game::Skill)
			self.data.charge_skills.each do |skill,n|
				temp = skill.newGameObj
				temp.extend(ChargeSkill)
				temp.charges = n
				@charge_skills[skill]=temp
			end
		end
		def charge_cs_stat_add(stat)#:nodoc:
			return 0 if stat != :price
			temp = 0
			@charge_skills.each_key {|k| temp += k.price * k.charges + k.data.charge_empty_price}
			return temp
		end
	end
	class Battler
		private
		def charge_cs_use(user,skill,target,key)#:nodoc:
			skill.charges -= 1 if skill.is_a?(ChargeSkill)
		end
	end
	class Equipment
		private
		def charge_cs_skills#:nodoc:
			result = Hash.new([])
			items.each {|item| item.charge_skills.each {|rskill,gskill| result[rskill] += [gskill] }}
			return result
		end
		def charge_cs_can_use_any(skill)#:nodoc:
			case skill
			when ChargeSkill
				return skill.charges > 1
			else
				return false
			end
		end
	end
end