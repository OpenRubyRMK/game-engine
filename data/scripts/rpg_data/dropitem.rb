require_relative "enemy"
require_relative "proxy"
require_relative "baseitem"

module RPG
	class Enemy
		attr_proxy :drop_items
		private
		def drop_items_cs_init#:nodoc:
			@drop_items= Proxy.new({},BaseItem,Float)
		end
	end
end
module Game
	class Enemy
		def drop_items
			result = Hash.new([])
			cs_drop_items {|h| h.each{|ritem,gitems| result[ritem] += gitems}}
			return result
		end
		private
		def drop_cs_drop_items#:nodoc:
			result = Hash.new([])
			self.data.drop_items.each do |item,rate|
				temp = rate
				cs_drop_rate_multi {|i| temp*=i}
				cs_drop_rate_add {|i| temp+=i}
				result[item] += item.newGameObj if rand() <= temp
			end
			return result
		end
	end
end