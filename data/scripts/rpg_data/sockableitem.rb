require "socket"
require "proxy"
module RPG::SockableItem
	def sockets
		@sockets ||= Proxy.new([],RPG::Socket)
		return @sockets
	end
	def sockets=(value)
		sockets.replace(value)
	end
end
module Game
	module SockableItem
		attr_reader :sockets
		
		def sock_item(i,item)
			return if sockets[i].nil?
			temp = sockets[i].item
			sockets[i].item=item
			return temp
		end
		
		def add_socket(sock)# sock is a RPG::Socket
			@sockets << Socket.new(sock)
		end
		
		private
		def sockable_cs_init#:nodoc:
			@sockets = data.sockets.map {|s| Socket.new(s)}
		end
		def sockable_cs_stat_add(stat)#:nodoc:
			temp=0
			@sockets.each do |i|
				if i.item.respond_to?("sock_#{stat}")
					temp += i.item.send("sock_#{stat}")
				elsif i.item.respond_to?("#{stat}")
					temp += i.item.send("#{stat}")
				end
			end
			return temp
		end
	end
end