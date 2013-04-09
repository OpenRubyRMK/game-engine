require "proxy"
require "baseitem"
module RPG
	class Socket
		include RPGClasses
		translation :name
		attr_reader :inc,:exc
		attr_writer :name
		def initialize(in_items=[],ex_items=[])
			@inc= Proxy.new([],BaseItem)
			self.inc = in_items
			@exc= Proxy.new([],BaseItem)
			self.exc = ex_items
			Socket.instances.push(self)
		end
		def === (item)
			temp = true
			temp = @inc.include?(item) if @inc.size == 0
			if @exc.include?(item)
				temp = false
			end
			return temp
		end
		def inc=(value)
			@inc.replace(value)
			return value
		end
		def exc=(value)
			@exc.replace(value)
			return value
		end
		
	end
end
module Game
	class Socket
		include GameClasses
		attr_reader :item		
		def initialize(sock)
			self.data = sock
			@item = nil
		end
		def item=(item)
			temp=@item
			@item=item if item.nil? || self === item.data
			return temp
		end
		def ===(item)
			return data === item
		end
	end
end