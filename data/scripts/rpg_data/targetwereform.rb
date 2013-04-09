require_relative "battlerskills"
require_relative "target"
require_relative "enemy"

module RPG
	class Target
		attr_proxy :wereform_any,:wereform_ally,:wereform_enemy,:wereform_user
		attr_proxy :wereform_cancel_any,:wereform_cancel_ally,:wereform_cancel_enemy,:wereform_cancel_user
		
		private
		def wereform_cs_init
			@wereform_any = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_ally = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_enemy = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_user = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_cancel_any = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_cancel_ally = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_cancel_enemy = Proxy.new(Hash.new(0),Enemy,Float)
			@wereform_cancel_user = Proxy.new(Hash.new(0),Enemy,Float)
		end
	end
end

module Game
	class Battler
		private
		def wereform_cs_use(user,item,target,key)
			return if target.respond_to?("wereform_#{key}")
			if !target.send("wereform_#{key}").empty?
				target.send("wereform_#{key}").each do |enemy,rate|
					temp = rate
					cs_wereform_rate_multi(enemy) {|i| temp*=i}
					cs_wereform_rate_add(enemy) {|i| temp+=i}
					if rand() <= temp
						@wereform = Enemy.new(enemy)
						return cs_wereform_change(enemy)
					end
				end
			elsif !@wereform.nil?
				rate = target.send("wereform_cancel_#{key}")[@wereform.data]
				cs_wereform_cancel_rate_multi(enemy) {|i| temp*=i}
				cs_wereform_cancel_rate_add(enemy) {|i| temp+=i}
				cs_wereform_change(@wereform = nil) if rand() <= temp
			end
		end
		
		def wereform_cs_skills
			return @wereform.nil? ? Hash.new([]) : @wereform.skills
		end
		
	end
end