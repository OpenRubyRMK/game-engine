require_relative "translation"
module RPG
	module RPGClasses
		include Comparable
		def id
			return self.class.find_index{|i| i.eql?(self)}
		end
		def <=>(other)
			return nil unless other.is_a?(self.class)
			return self.id <=> other.id
		end
		def self.included(base)
			super(base)
			base.extend(Singleton)
		end
		module Singleton
			include Enumerable
			include Translation
			
			def attr_proxy(*names)
				attr_reader(*names)
				names.each do |n|
					define_method("#{n}=") do |value|
						instance_variable_get("@#{n}".to_sym).replace(value)
					end
				end
			end
			def attr_rpg(meth,type)
				define_method(meth) { return type[instance_variable_get("@#{meth}".to_sym)] }
				define_method("#{meth}=") {|value| return instance_variable_set("@#{meth}".to_sym,type.find_index(value)) }
			end
			def instances
				@instances = [] if @instances.nil?
				return @instances
			end
			def instances=(array)
				instances.replace(array)
			end
			def each(&block)
				instances.each(&block)
			end
			def [](id)
				return nil if id.nil?
				return instances[id]
			end
		end
	end
end
