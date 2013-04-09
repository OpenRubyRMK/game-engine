require_relative "battler_equipment"
require_relative "skill"
module RPG
	module EquipableItem
		attr_reader :charge_skills
		private
		def charge_skills_cs_init_equipable
			@charge_skills = {}
		end
		def charge_skills_cs_to_xml_equipable(xml)
			xml.charge_skills{
				@charge_skills.each{|n,c| xml.skill(:name=>n,:charges=>c)}
			}
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
			@charge_skills = {}
			rpg.charge_skills.each do |skill,n|
				temp = Skill.new(skill)
				temp.extend(ChargeSkill)
				temp.charges = n
				@charge_skills[skill]=temp
			end
		end
		def charge_cs_stat_add(stat,key)#:nodoc:
			return 0 if stat != :price
			return @charge_skills.map {|k,v|
				v.price * v.charges + v.rpg.charge_empty_price
			}.inject(0,:+)
		end
	end
end
