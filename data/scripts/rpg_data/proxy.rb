class Proxy
	module ProxyHash
		attr_reader :value_type,:key_type
		def [](key)
			key = check_type(key,@key_type)
			unless @value.include?(key)
				begin
					return @value[key]=@value.default.dup
				rescue
					return @value[key]=@value.default
				end
				return nil
			end
			value = @value[key]
			value = @value_type[value] if @value_type.respond_to?(:[])
			return value
		end
		def []=(key,value)
			key = check_type(key,@key_type)
			unless @value.include?(key)
				begin
					@value[key]=@value.default.dup
				rescue
					@value[key]=@value.default
				end
			end
			value = check_type(value,@value_type)
			if @value[key].respond_to?(:replace)
				@value[key].replace(value)
			else
				@value[key]=value
			end
			return value
		end
		def method_missing(methID,*args,&block)
			case methID
			when :include?,:has_key?,:key?,:member?,:delete
				args[0] = check_type(args[0],@key_type)
			when :key,:default=,:index,:has_value?,:value?
				args[0] = check_type(args[0],@value_type)
			when :values_at
				args.map! { |o| check_type(o,@key_type) }
			when :replace
				clear
				args[0].each {|k,v| self[k]=v}
				return self
			when :fetch
				unless include?(args[0])
					if args[1].nil?
						if block_given?
							return block.call(args[0])
						else
							raise(KeyError.new("key not found"))
						end
					else
						return args[1]
					end
				else
					return self[args[0]]
				end
			when :shift
				return default if empty?
			when :store
				return self[args[0]]=args[1]
			when :merge
				return self.dup.merge!(args[0],&block)
			when :default_proc,:default_proc=,:assoc,:rassoc,:compare_by_identity,:compare_by_identity?,:yaml_initialize
				return super(methID,*args,&block)
			when :flatten
				return to_hash.send(methID,*args,&block)
			end
			result = @value.send(methID,*args,&block)
			case methID
			when :keys
				return Proxy.new(result,@key_type) unless @key_type.nil? || @key_type.is_a?(Proxy)
			when :values,:values_at
				return Proxy.new(result,@value_type) unless @value_type.nil?
			when :rehash
				return self
			when :default
				result = @value_type[result] if @value_type.respond_to?(:[])
			when :to_hash
				result = {}
				self.each {|k,v| result[k]=v}
			when :delete
				if result.nil?
					return block.call(args[0]) if block_given?
					return nil
				else
					result = @value_type[result] if @value_type.respond_to?(:[])
				end
			when :shift
				result[0] = @key_type[result[0]] if @key_type.respond_to?(:[])
				result[1] = @value_type[result[1]] if @value_type.respond_to?(:[])
			when :invert
				return Proxy.new(result,@value_type,@key_type)
			end
			return result
		end
		
		def each_key(&block)
			return block_given? ? keys.each(&block) : Enumerator.new(self,:each_key)
		end
		
		def each_value(&block)
			return block_given? ? values.each(&block) : Enumerator.new(self,:each_value)
		end
		def each_pair(&block)
			each(&block)
		end
		def each(&block)
			if block_given?
				@value.each {|k,v|
					k = @key_type[k] if @key_type.respond_to?(:[])
					v = @value_type[v] if @value_type.respond_to?(:[])
					yield k,v }
				return self
			else
				return Enumerator.new(self)
			end
		end
		def delete_if(&block)
			if block_given?
				@value.delete_if {|k,v|
					k = @key_type[k] if @key_type.respond_to?(:[])
					v = @value_type[v] if @value_type.respond_to?(:[])
					yield k,v}
				return self
			else
				return Enumerator.new(self,:delete_if)
			end
		end
		
		def reject!(&block)
			if block_given?
				@value.reject! {|k,v|
					k = @key_type[k] if @key_type.respond_to?(:[])
					v = @value_type[v] if @value_type.respond_to?(:[])
					yield k,v}
				return self
			else 
				return  Enumerator.new(self,:reject!)
			end
		end
		
		def respond_to?(methID)
			return false if [:default_proc,:default_proc=,:assoc,:rassoc,:compare_by_identity,:compare_by_identity?,:yaml_initialize].include?(methID)
			return super(methID) || @value.respond_to?(methID)
		end
		
		def merge!(other,&block)
			other.to_hash.each { |k,v| self[k]= block_given? ? block.call(k,self[k],v) : v}
			return self
		end
		alias_method :update, :merge!
	end
	module ProxyArray
		attr_reader :value_type
		attr_accessor :max_size
		def [](*args)
			value = @value[*args]
			if args.size > 1 || args[0].is_a?(Range)
				return Proxy.new(value,@value_type)
			else
				value = @value_type[value] if @value_type.respond_to?(:[])
				return value
			end
		end
		def []=(*keys,value)
			if keys.size > 1 || keys[0].is_a?(Range)
				if value.is_a?(Array)
					@value[*keys]= value.map { |o| check_type(o,@value_type) }
				else
					@value[*keys]= check_type(value,@value_type)
				end
			else
				value = check_type(value,@value_type)
				if @value[*keys].respond_to?(:replace)
					@value[*keys].replace(value)
				else
					@value[*keys]=value
				end
			end
			return value
		end
		def method_missing(methID,*args,&block)
			case methID
			when :unshift, :push
				args.map! { |o| check_type(o,@value_type) }
			when :replace,:concat
				args[0] = args[0].map { |o| check_type(o,@value_type) }
			when :delete,:include?, :"<<",:rindex
				args[0] = check_type(args[0],@value_type)
			when :insert
				i = args.shift
				args.map { |o| check_type(o,@value_type) }
				args.unshift(i)
			when :fill
				if block_given?
					args[0] = 0 if args.size == 0
					args[1] = size-args[0] if args.size == 1
					args[0].upto(args[1]-1) do |i|
						result = block.call(i)
						check_type(result,@value_type)
					end
					return self
				else
					args[0] = check_type(args[0],@value_type)
				end
			when :sort!
				if block_given?
					block = proc do |x,y|
						x = @value_type[x] if @value_type.respond_to?(:[])
						y = @value_type[y] if @value_type.respond_to?(:[])
						yield x,y
					end
				end
			when :slice
				return self[*args]
			when :+,:-,:&,:|
				if value_type.is_a?(Module)
					if args[0].is_a?(Proxy)
						result = []
						case value_type <=> args[0].value_type
						when 1,0
							result = Proxy.new([],value_type)
						when -1
							result = Proxy.new([],args[0].value_type)
						when nil
							result = Proxy.new([],(self.value_type.ancestors & args[0].value_type.ancestors).first)
						end
						result.replace(to_a.send(methID,args[0].to_a))
						return result
					else
						temp = value_type.ancestors
						check_type(args[0],Array).each {|o| temp &= o.class.ancestors}
						result = Proxy.new([],temp.first)
						result.replace(to_a.send(methID,check_type(args[0],Array)))
						return result
					end
				end
			when :transpose,:flatten,:to_ary,:combination,:product,:join,:*
				return to_a.send(methID,*args,&block)
			when :flatten!,:map!,:pack,:collect!,:assoc,:rassoc
				return super(methID,*args,&block)
			end
			result = @value.send(methID,*args,&block)
			case methID
			when :unshift, :push,:replace,:concat,:<<
				shift while size > @max_size
			end unless @max_size.nil?
			case methID
			when :fetch
				begin
					@value.fetch(args[0])
					result = @value_type[result] if @value_type.respond_to?(:[])
				rescue
				end
			when :reverse,:shuffle,:uniq
				result.map!  {|o| @value_type.respond_to?(:[]) ? @value_type[s] : s }
			when :slice!
				if args.size > 1 || args[0].is_a?(Range)
					result = Proxy.new(result,@value_type)
				else
					result = @value_type[result] if @value_type.respond_to?(:[])
				end
			when :sample,:last
				if args.size > 0
					result.map!  {|o| @value_type.respond_to?(:[]) ? @value_type[o] : o }
				else
					result = @value_type[result] if @value_type.respond_to?(:[])
				end
			when :shift,:pop,:at,:delete_at
				result = @value_type[result] if @value_type.respond_to?(:[])
			when :delete,:fill,:"<<",:sort!,:concat,:reverse!,:shuffle!,:insert,:uniq!,:clear
				return self
			end
			return result
		end
		
		
		#Nicht in method_missing weil Enumerator sie sonst nicht findet
		def index(*args)
			return find_index(*args,&block)
		end
		def each(&block)
			if block_given?
				@value.each  {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else
				return Enumerator.new(self)
			end
		end
		def delete_if(&block)
			if block_given?
				@value.delete_if {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else 
				return  Enumerator.new(self,:delete_if)
			end
		end
		def reject!(&block)
			if block_given?
				@value.reject! {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else 
				return  Enumerator.new(self,:reject!)
			end
		end
		def respond_to?(methID)
			return super(methID) || (![:flatten!,:map!,:pack,:collect!,:assoc,:rassoc].include?(methID) && @value.respond_to?(methID))
		end
	end
	module ProxySet
		attr_reader :value_type
		def method_missing(methID,*args,&block)
			case methID
			when :&,:intersection,:|,:+,:union,:-,:difference,:^,:replace,:merge,:subtract
				args[0] = args[0].map { |o| check_type(o,@value_type) }
			when :<<,:add,:add?,:delete,:delete?
				args[0] = check_type(args[0],@value_type)
			when :flatten!,:map!,:collect!,:flatten_merge,:initialize_copy,:proper_subset?,:proper_superset?,:subset?,:superset?
				return super(methID,*args,&block)
			end
			result = @value.send(methID,*args,&block)
			case methID
			when :&,:intersection,:|,:+,:union,:-,:difference,:^,:subtract
				result = Proxy.new(result,@value_type)
			when :add,:<<,:clear,:replace,:merge,:delete
				return self
			when :add?,:delete?
				return result.nil? ? nil : self
			end
			return result
		end
		def each(&block)
			if block_given?
				@value.each  {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else
				return Enumerator.new(self)
			end
		end
		def classify(&block)
			if block_given?
				result = @value.classify  {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				result.each {|key,value| result[key]=Proxy.new(value,@value_type)}
				return result
			else
				return Enumerator.new(self,:classify)
			end
		end
		def delete_if(&block)
			if block_given?
				@value.delete_if {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else 
				return  Enumerator.new(self,:delete_if)
			end
		end
		def reject!(&block)
			if block_given?
				@value.reject! {|s| yield @value_type.respond_to?(:[]) ? @value_type[s] : s }
				return self
			else 
				return  Enumerator.new(self,:reject!)
			end
		end
		def respond_to?(methID)
			return super(methID) || (![:flatten!,:map!,:collect!,:flatten_merge,:initialize_copy,:proper_subset?,:proper_superset?,:subset?,:superset?].include?(methID) && @value.respond_to?(methID))
		end
	end
	module ProxyNumeric
		def method_missing(methID,*args,&block)
			case methID
				when :replace
					if args[0].is_a?(Proxy)
						case args[0]
						when Integer
							@value =args[0].to_i
						when Float
							@value =args[0].to_f
						when Rational
							@value =args[0].to_r
						when Complex
							@value =args[0].to_c
						end
					else
						@value =args[0]
					end
					return self
			end
			result = @value.send(methID,*args,&block)
			case methID
				when :+,:-,:*,:**,:"/"
					result=[result,@min].max if @min
					result=[result,@max].min if @max
					result = Proxy.new(result,@min,@max)
			end
			return result
		end
		def to_s
			@value.to_s
		end
		def inspect
			@value.inspect
		end
	end
	
	include Enumerable
	attr_reader :value
	protected :value
	def initialize(value,key_type=nil,value_type=nil)
		@value = value.is_a?(Class) ? value.new : value
		if value.is_a?(Array)
			@key_type =nil
			@value_type =key_type
			self.extend(ProxyArray)
		end
		if value.is_a?(Hash)
			@key_type =key_type
			self.extend(ProxyHash)
			if value_type.is_a?(Module) || value_type.instance_of?(Array)
				@value_type = value_type
			else
				@value.default = value_type
			end
		end
		if Object.const_defined?(:Set)
			if value.is_a?(Set)
				@key_type =nil
				@value_type =key_type
				self.extend(ProxySet)
			end
		end
		if value.is_a?(Numeric)
			self.extend(ProxyNumeric)
			@min = key_type
			@max = value_type
		end
	end
	def is_a?(klass)
		return true if super
		return @value.is_a?(klass)
	end
	def kind_of?(klass)
		return true if super
		return @value.kind_of?(klass)
	end
	
	def ==(other)
		return other.is_a?(Proxy) && @value == other.value
	end
	
	def eql?(other)
		return other.is_a?(Proxy) && @value.eql?(other.value)
	end
	def hash
		return @value.hash
	end
	def dup
		temp=super
		begin
			temp.instance_variable_set(:@value,@value.dup)
		rescue
			temp.instance_variable_set(:@value,@value)
		end
		case @value
		when Array
			temp.extend(ProxyArray)
		when Hash
			temp.extend(ProxyHash)
		when Numeric
			temp.extend(ProxyNumeric)
		else
			temp.extend(ProxySet) if Object.const_defined?(:Set) && @value.is_a?(Set)
		end
		return temp
	end
	private
	def check_type(object,type)
		error = false
		if type.is_a?(Module)
			begin
				unless object.is_a?(type)#Folgendes geht nicht als Case
					return object.to_s if type == String
					return object.to_i if type == Integer
					return object.to_f if type == Float
					return object.to_r if type == Rational
					return object.to_c if type == Complex
					return object.to_a if type == Array
					return object.to_hash if type == Hash
					return object.to_sym if type == Symbol
					return object.to_enum if type == Enumerator
					return object.to_set if Object.const_defined?(:Set) && type == Set
					raise(NoMethodError)
				end
			rescue NoMethodError
				raise(TypeError.new)
			end
		elsif type.instance_of?(Proxy)
			result = type.dup
			result.replace(object)
			return result
		elsif type.instance_of?(Array)
			raise(IndexError.new) unless type.include?(object)
		end
		return type.respond_to?(:find_index) ? type.find_index(object) : object
	end
end