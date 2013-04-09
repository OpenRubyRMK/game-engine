require_relative "baseobject"

module RPG
	class Group < BaseObject
		attr_accessor :type,:members
		include Enumerable
		def initialize(name)
			super
			@type = :BaseObject
			@members = []
		end
		
		def each
			return to_enum(__method__) unless block_given?
			@members.each {|i| yield RPG.const_get(@type)[i.to_sym]} 
			return self
		end
		
		private
		def group_cs_to_xml(xml)
			xml.parent["type"]=@type.to_s
			xml.members {
				@members.each {|o|
					xml.member(:name => o)
				}
			}
		end
	end
end