require_relative "actoractorclass"
require_relative "mastery"
module RPG
	class ActorClass
		##
		# :attr_accessor: mastery
		attr_proxy :mastery 
		private
		def mastery_cs_init#:nodoc:
			@mastery = Proxy.new(Hash.new(1.0),Mastery,Float)
		end
	end
end
module Game
	class Actor
		attr_reader :mastery
		
		def gain_mastery_exp(m,exp)
			return unless @mastery.include?(m)
			cs_mastery_exp_multi(m) {|i| exp *= i}
			cs_mastery_exp_add(m) {|i| exp += i}
			@mastery[m].exp+=exp
		end
		private
		#:stopdoc:
		def mastery_cs_init
			@mastery = Proxy.new({},RPG::Mastery,Game::Mastery)
		end
		def actorclass_cs_mastery_exp_multi(m)
			result=1
			self.actorclass.each_key {|ac| result *= ac.mastery[m] }
			return result
		end
		def mastery_cs_add_actorclass(ac)
			ac.mastery.each_key {|m| @mastery[m] = Game::Mastery.new(m) if @mastery.include?(m) }
		end
		#:startdoc:
	end
end