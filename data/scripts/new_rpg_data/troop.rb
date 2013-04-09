require_relative "unit"
require_relative "enemy"

module RPG
	class Troop < BaseObject
		attr_accessor :members
		def initialize(name)
			super
			@members = []
		end
		private
		def members_cs_to_xml(xml)
			xml.members{ @members.each{|m| xml.member(:name=>m)}}
		end
		def member_cs_parse(node)
			node.xpath("members/member").each {|ac|
				@members << ac["name"].to_sym
				Enemy.parse_xml(ac) unless ac.children.empty?
			}
		end
	end
end
module Game
	class Troop < Unit
		def initialize(name)
			super
		end
		def rpg
			return RPG::Troop[@name]
		end
		def create_member(key)
			return Game::Enemy.new(key)
		end
	end
end
