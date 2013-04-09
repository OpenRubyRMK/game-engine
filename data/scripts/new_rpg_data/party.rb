require_relative "unit"
require_relative "actor"

module RPG
	class Party < BaseObject
		attr_reader :name
		attr_accessor :members
		def initialize(name)
			@members = []
			super
		end
		def members_cs_to_xml(xml)
			xml.members{ @members.each{|m| xml.member(:name=>m)}}
		end
		def member_cs_parse(node)
			node.xpath("members/member").each {|ac|
				@members << ac["name"].to_sym
				Actor.parse_xml(ac) unless ac.children.empty?
			}
		end
	end
end
module Game
	class Party < Unit
		attr_reader :name
		def initialize(name)
			super
			self.class.current ||= self
		end
		def rpg
			return RPG::Party[@name]
		end
		def create_member(key)
			return Game::Actor.new(key)
		end
		class << self
			attr_accessor :current
		end
	end
end
