require_relative "csmod"
module Game
	class Unit
		attr_accessor :members,:removed_members
		attr_reader :name
		def initialize(name)
			@name = name
			@members = {}
			@removed_members = {}
			rpg.members.each {|k| add_member(k) }
			cs_init
		end
		def rpg
			raise NotImplementedError
		end
		def each(&block)
			@members.each_value(&block)
			return self
		end
		
		def add_member(k)
			if @removed_members.include?(k)
				@members[k] = @removed_members.delete(k)
			else
				@members[k] = create_member(k)
			end
			cs_add_member(k)
		end
			
		def remove_member(k)
			if @members.include?(k)
				@removed_members[k] = @members.delete(k)
				cs_remove_member(k)
			end
		end
		
		def create_member(k)
			raise NotImplementedError
		end
	end
end
