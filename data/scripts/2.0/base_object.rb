#require "nokogiri"

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
