class Object
	def method_missing(methId, *args)
		if /^cs_/.match(methId)
			@__cs_cache ||={}
#			if singleton_class.ancestors.any?{|m| m.cs_need_reload(methId)}
#				@__cs_cache.delete(methId)
#				p methId
#				p singleton_class.ancestors
#				singleton_class.ancestors.each do |m|
#					m.instance_variable_get(:@__cs_need_reload).delete(methId)
#				end
#			end
			unless @__cs_cache.has_key?(methId)
				req = /_#{methId}$/
				@__cs_cache[methId] = (methods | protected_methods | private_methods ).find_all { | m | req.match(m) }.sort
				#p self,@__cs_cache[methId] if methId == :cs_init
			end
			result = @__cs_cache[methId].map { |m| send(m, *args) }
			if block_given?
				return result.each {|s| yield s}
			else
				return result
			end
		else
			super
		end
	end

	def cs_cache_clear(key=nil)
		return if @__cs_cache.nil?
		if key.nil?
			@__cs_cache.clear
		else
			@__cs_cache.delete(key)
		end
	end
#	def singleton_method_added(meth)
#		@__cs_cache ||={}
#		if(match = /^_(cs_.+)$/.match(meth))
#			@__cs_cache[match[1].to_sym] = [] unless @__cs_cache.include?(match[1].to_sym)
#			@__cs_cache[match[1].to_sym] << meth
#		end
#	end
end
#class Module
#	alias_method :cs_method_added, :method_added
#	def method_added(meth)
#		cs_method_added(meth)
#		@__cs_need_reload ||= []
#		if(match = /^_(cs_.+)$/.match(meth))
#			@__cs_need_reload << match[1].to_sym
#		end
#	end
#	
#	def cs_need_reload(meth)
#		@__cs_need_reload ||= []
#		@__cs_need_reload.include?(meth)
#	end
#end
