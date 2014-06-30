require "nokogiri"
require "observer"

module RPG
  class BaseObject
    attr_reader :name
    include Comparable
    def initialize(name)
      @name = name
      self.class[name] = self
    end

    def to_sym
      return @name
    end

    def <=>(value)
      return @name <=> value.to_sym
    end

    #methods needed no be overwritten or extended to add parsable stuff
    def _to_xml(xml)
    end

    def parse_xml(xml)
    end

    def to_xml
      builder = Nokogiri::XML::Builder.new do |xml|
        n = self.class.name.split("::").last.downcase
        xml.send(n,:name=>@name) {
          _to_xml(xml)
        }
      end
      return builder.to_xml
    end

    class << self
      include Enumerable
      attr_reader :childs,:instances
      def parse_xml(path)
        if path.is_a?(Nokogiri::XML::Element)
          temp = new(path[:name].to_sym)
          temp.parse_xml(path)
          return temp
        end

        results = []
        if path.is_a?(Nokogiri::XML::Document)
          doc = path
        elsif(File.exist?(path))
          doc = Nokogiri::XML(File.read(path))
        else
          doc = Nokogiri::XML(path)
        end
        n = name.split("::").last.downcase
        doc.xpath("*/#{n}",n).each {|node|
          results << parse_xml(node)
        }
        return results
      end

      def each(&block)
        return to_enum(__method__) unless block_given?
        @instances ||= {}
        @instances.each_value(&block)
        @childs ||= []
        @childs.each {|c| c.each(&block) }
        return self
      end

      def [](i)
        @instances ||= {}
        return @instances[i] if @instances.include?(i)
        @childs ||= []
        @childs.each do |c|
          temp = c[i]
          return temp if temp
        end
        return nil
      end

      def []=(i,o)
        @instances ||= {}
        @instances[i] = o
      end

      def inherited(child)
        @childs ||= []
        @childs << child
      end
    end
  end
end


module Game
  extend Observable
  def self.observe(target_event = nil)
    callback = lambda do |event, emitter, info|
      yield(event, emitter, info) if !target_event || event == target_event
    end

    add_observer(callback, :call)
  end

  class BaseObject
    attr_reader :name
    def initialize(name,*)
      @name = name
    end

    def to_sym
      return @name
    end

    def rpg
      raise NotImplementedError
    end

    def observe(target_event = nil)
      Game.observe(target_event) do |event, emitter, info|
          yield(event, emitter, info) if emitter == self
      end
    end
    
    def notify_observers(event, info = {})
      if block_given?
        Game.changed
        info = yield
      end
      Game.notify_observers(event, self, info)
      info
    end

		private
		def _list_group_by(list, k)
			return k ? list : list.group_by(&:name)
		end
		
		def _list_combine(list, key, default, sym)
			if key
				return list.map {|h| h[key] }.inject(default,sym)
			else
				return temp.inject(Hash.new(default)) do |element,hash|
					hash.merge(element) {|k,o,n| o.send(sym,n)}
				end
			end
		end
	end
end
