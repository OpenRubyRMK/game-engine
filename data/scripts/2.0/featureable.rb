require_relative "feature"
module RPG
  module Featureable
    attr_accessor :features
    def add_feature(*args)
      f = Feature.new(*args)
      yield f if block_given?  
      @features << f
    end
    
    
    def initialize(*)
      super
      @features = []
    end
    
    def _to_xml(xml)
      super
      xml.features{
        @features.each{|feature| feature.to_xml(xml)}
      }
    end

    def parse_xml(level)
      super
      level.xpath("features/feature").each {|node|
        @features << Feature.parse_xml(node)
      }
    end
  end
end

module Game
  module Featureable
    attr_reader :features
    
    def initialize(name,*)
      super
      @features = (name.is_a?(Symbol) ? rpg : name).features.map {|n|Feature.new(n)}
    end
  end
end
