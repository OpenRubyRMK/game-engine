module Game
	module GameClasses
		def data
			return RPG.const_get(self.class.name.split("::").last)[@data]
		end
		def data=(value)
			@data=RPG.const_get(self.class.name.split("::").last).find_index(value)
			return value
		end
		def self.included(base)
			super(base)
			base.extend(Singleton)
		end
		module Singleton
			def attr_proxy(*names)
				attr_reader(*names)
				names.each do |n|
					define_method("#{n}=") do |value|
						instance_variable_get("@#{n}".to_sym).replace(value)
					end
				end
			end
		end
	end
	class << self
		def [](key)
			@hash = {} if @hash.nil?
			@hash[key]
		end
		def[]=(key,value)
			@hash = {} if @hash.nil?
			@hash[key]=value
		end
	end
end