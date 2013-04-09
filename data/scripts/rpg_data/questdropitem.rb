require_relative "dropitem"
require_relative "quest"

module RPG
	class Enemy
		attr_proxy :quest_items
		private
		def quest_items_cs_init#:nodoc:
			@quest_items= Proxy.new({},Quest,Proxy.new({},BaseItem,Float))
		end
	end
end
module Game
	class Enemy
		private
		def drop_cs_drop_items#:nodoc:
			result = Hash.new([])
			if !Game[:party].nil?
				self.data.quest_items.each do |quest,proxy|
					if Game[:party].quests.include?(quest) && Game[:party].quests[quest].active?
						proxy.each do |item,rate|
							temp = rate
							cs_drop_rate_multi {|i| temp*=i}
							cs_drop_rate_add {|i| temp+=i}
							result[item] += item.newGameObj if rand() <= temp
						end
					end
				end
			end
			return result
		end
	end
end