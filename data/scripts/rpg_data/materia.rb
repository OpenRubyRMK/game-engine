require "baseitem"
require "sockableitem"
require "skill"
require "levelble"
require "equipment"
module RPG
	class Materia < BaseItem
		include Levelble
		attr_reader :skills
		def initialize
			super
			@skills = Proxy.new({},nil,Proxy.new([],Skill))
		end
		def skills=(value)
			@skills.replace(value)
			return value
		end
		class << self
			def each(&block)
				superclass.find_all{|i| i.is_a?(self)}.each(&block)
			end
			def [](id)
				return nil if id.nil?
				return superclass.find_all{|i| i.is_a?(self)}[id]
			end
		end
	end
end
module Game
	class Materia < BaseItem
		include Levelble
		attr_reader :skills
		
		def skills=(value)
			@skills.replace(value)
			return value
		end
		private
		def skills_cs_init
			@skills=Proxy.new({},RPG::Skill,Game::Skill)
		end
		def skills_cs_levelup(level)
			self.data.skills[level].each {|skill| @skill[skill]= skill.newGameObj}		                             
		end	
	end
	class Equipment
		private
		def materia_cs_skills
			result = Hash.new([])
			items.each { |i| i.sockets.each { |s| s.item.skills.each {|k,v| result[k]+=v} if s.item.is_a?(Materia) } if i.is_a?(SockableItem) }
			return result
		end
	end
end