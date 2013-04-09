require_relative "baseobject"
module RPG
	class Element < BaseObject
		attr_accessor :state,:visible
		#translation :name
		def initialize(name,state=0,visible=true)
			super(name)
			cs_init
		end
		def physical?
			return [1,3].include?(@state)
		end
		def magical?
			return [2,3].include?(@state)
		end
		private
		def element_cs_to_xml(xml)
			xml.state @state
			xml.visible @visible
		end
		def element_cs_parse(node)
			@state = node[:name].to_f
			@visible = node[:visible].to_f
		end
	end
end
