class ChapterSystem
	def initialize
		@chapters = []
	end
	def add_chapter(key,name)
		@chapters[key]=Chapter.new(name)
	end
	def each(&block)
		@chapters.each(&block)
	end
	def update
		cs_update
		if @chapters.none?{|c| c.active?} && !(temp=@chapters.find{|c| c.unactive?}).nil?
			temp.active!
		end
		@chapters.each(&:update)
	end
	def chapter
		@chapters.find{|c| c.active?}
	end
	class Chapter
		attr_reader :state
		attr_writer :name,:finish
		def initialize(name)
			@name = name
			@state = :chapterlog_state_unactive
		end
		def name(&block)
			if block_given?
				@name = block
			end
			case @name
			when nil
				return ""
			when Proc
				L[@name.call]
			else
				L[@name]
			end
		end
		def finish(&block)
			if block_given?
				@finish = block
			end
			return @finish
		end
		def update
			cs_update
			if @finish.is_a?(Proc)
				finish! if @finish.call
			end
		end
		def unactive!
			state = :chapterlog_state_unactive
		end
		def active!
			state = :chapterlog_state_active
		end
		def finish!
			state = :chapterlog_state_finsh
		end
		def unactive?
			return state == :chapterlog_state_unactive
		end
		def active?
			return state == :chapterlog_state_active
		end
		def finish?
			return state == :chapterlog_state_finsh
		end
	end
end
