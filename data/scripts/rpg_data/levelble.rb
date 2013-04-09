module RPG
	module Levelble
		attr_accessor :exp_basis,:exp_inflation,:max_level
		attr_writer :initial_level
		def initial_level
			return @initial_level.nil? ? 0 : @initial_level 
		end
	end
end

module Game
	module Levelble
		attr_reader :max_level,:exp
		def max_level=(value)
			@max_level = value
			@exp_list.clear
			@exp_list[0]=0
			m = data.exp_basis
			n = 0.75 + data.exp_inflation / 200.0;
			(1..(@max_level-1)).each { |i|
				@exp_list[i] = @exp_list[i-1] + m.to_i
				m *= 1 + n;
				n *= 0.9;
			}
			return value
		end
		def level
			@exp_list.each_with_index {|o,i| return i if o > @exp }
		end
		def exp=(value)
			temp = level
			@exp = value
			(temp+1).upto(level) {|l| cs_levelup(l)}
		end
		def level=(value)
			self.exp=@exp_list[value]
		end
		private
		def levelble_cs_init
			@exp_list=[]
			self.max_level = data.max_level
			@exp=@exp_list[data.initial_level.nil? ? 0 : data.initial_level]
		end
	end
end