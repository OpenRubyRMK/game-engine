require_relative "baseobject"

module RPG
	class Quest < BaseObject

		include Enumerable
		attr_accessor :childs

		attr_accessor :started_childs

		attr_accessor :parents
		
		
		def initialize(name)
			super
			@childs = []
			@started_childs = []
			@parents = []
		end
		def each
			return to_enum(__method__) unless block_given?
			@childs.each{|i| yield Quest[i]}
			return self
		end
		private
		def quest_to_xml(xml)
			xml.parents {
				parents.each{|par|xml.parent(:name=>par)}
			}
			xml.childs {
				childs.each{|chi|xml.child(:name=>chi)}
			}
			xml.finish{cs_to_xml_finish(xml)}
			xml.failed{cs_to_xml_failed(xml)}
		end
	end
end
module Game
	class Quest
		include Enumerable
		attr_reader :name
		
		attr_reader :started,:finish,:failed
		
		def rpg
			return RPG::Quest[@name]
		end
		def initialize(name)
			@started = false
			@failed = false
			@name = name
		end
		def each
			return to_enum(__method__) unless block_given?
			rpg.childs.each{|i| yield Quest[i]}
			return self
		end
		def started=(value)
			@started = value
			rpg.started_childs.each{|i|Quest[i].started=true} if(value)
		end
		def finish=(value)
			@finish = value
			if(value)
				Quest.each do |o|
					temp = o.rpg.childs
					if temp.include?(@name) && temp.all?{|child| Quest[child].finish}
						o.finish = true
					end
					temp = o.rpg.parents
					if temp.include?(@name) && temp.all?{|parent| Quest[parent].finish}
						o.started = true
					end
				end
			end
		end
		def failed=(value)
			@failed = value
			Quest.each { |o| o.failed = true if o.rpg.childs.include?(@name)} if(value)
		end
		class << self
			include Enumerable
			def each
				raise NotImplementedError
			end
			def [](i)
				raise NotImplementedError
			end
			def []=(i,o)
				raise NotImplementedError
			end
		end
	end
end
