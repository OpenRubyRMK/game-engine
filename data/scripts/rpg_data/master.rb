require_relative "actoractorclass"

require_relative "battlerskills"
require_relative "equipableitem"
require_relative "equipment"
module RPG::EquipableItem
	#mastery {RPG::ActorClass => {RPG::Skill => value} }
	def master
		@master = Proxy.new({},RPG::ActorClass,Proxy.new({},RPG::Skill)) if @master.nil?
		return @master
	end
	def master=(value)
		master.replace(value)
	end
end
module Game
	module EquipLearnSkill
		attr_writer :learn_value
		def learn_value
			return @learn_value.nil? ? 0 : @learn_value
		end
		def master
			return self.data.master
		end
	end

	class Battler
		private
		def equiplearnskill_cs_use(user,skill,target,key)#:nodoc: #game::skill
			return unless skill.is_a?(EquipLearnSkill)
			user.instance_eval do 
				max_value = self.actorclass.map do |rc,ac|
					equipment.items.map do |item|
						nil if item.respond_to?(:master)
						item.master[ac][skill.data]
					end
				end
				max_value=max_value.flatten.compact.min
				return if max_value.nil?
				case skill.learn_value <=> max_value
				when -1
					skill.learn_value += 1
				when 0
					@equiplearnskill_learned[skill.data] = skill.data.makenewObj
					@equiplearnskill.delete(skill.data)
				end
			end
		end
	end
	class Actor
		private
		def equiplearnskill_cs_init#:nodoc:
			@equiplearnskill_learned = Proxy.new({},RPG::Skill,Game::Skill)
			@equiplearnskill = Proxy.new({},RPG::ActorClass,Proxy.new({},RPG::Skill,Game::EquipLearnSkill)) #last is only set for type check
		end
		def equiplearnskill_cs_can_use_any(skill)#:nodoc:
			case skill
			when RPG::Skill
				return true if @equiplearnskill_learned.include?(skill)
				return self.actorclass.any? do |ac|
					@equiplearnskill[ac].include?(skill) && self.equipment.items.any? do |item|
						item.respond_to?(:master) && item.master[ac].include?(skill)
					end
				end
			when Game::Skill
				return true if @equiplearnskill_learned[skill.data] == skill
				return self.actorclass.any? do |ac|
					@equiplearnskill[ac][skill.data] == skill && self.equipment.items.any? do |item|
						item.respond_to?(:master) && item.master[ac].include?(skill.data)
					end
				end
			else
				return false
			end
		end
		
		def equiplearnskill_cs_skills#:nodoc:
			result = Hash.new([])
			@equiplearnskill_learned.each {|rs,gs| result[rs]+=[gs]}
			@equiplearnskill.each_values{|pr| pr.each {|rs,gs| result[rs]+=[gs]}}
			return result
		end
	end

	class Equipment
		private
		def equiplearnskill_cs_equip(key,item)#:nodoc:
			return unless item.respond_to?(:master)
			return if !actor.respond_to?(:actorclass) || actor.actorclass.nil?
			actor.actorclass.each_key do |ac|
				item.master[ac].each do |s,*|
					actor.instance_eval do
						unless @equiplearnskill_learned.include?(skill) || @equiplearnskill[ac].include?(skill)
							@equiplearnskill[ac][skill]=skill.makenewObj.extend(EquipLearnSkill)
						end
					end
				end
			end
			return nil
		end
	end
end
