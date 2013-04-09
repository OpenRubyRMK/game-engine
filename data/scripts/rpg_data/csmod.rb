class Object
	def method_missing(methId, *args)
		if /^cs_/.match(methId)
			@__cs_cache ||={}
			unless @__cs_cache.has_key?(methId)
				req = /_#{methId}$/
				@__cs_cache[methId] = (methods | protected_methods | private_methods ).find_all { | m | req.match(m) } 
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
end