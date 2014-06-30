require_relative "feature"
module RPG
  module Featureable
    attr_accessor :features
    def add_feature(*args)
      f = Feature.new(*args)
      yield f if block_given?
      @features << f
      return f
    end
    
    
    def initialize(*)
      super
      @features = []
    end
    
    def parse_xml(level)
      super
      level.xpath("features").each {|node|
        feature_parse_xml(node)
      }
    end

		private

		def _list_group_by(list, k)
			return k ? list : list.group_by(&:name)
		end
		
		def _list_combine(list, key, default, sym)
			if key
				return list.map {|h| h[key] }.inject(default,sym)
			else
				return list.inject(Hash.new(default)) do |element,hash|
					hash.merge(element) {|k,o,n| o.send(sym,n)}
				end
			end
		end
		
		def _featureable_helper(&block)
			features.flat_map(&block)
		end

    def _to_xml(xml)
      super
      xml.features{
        feature_to_xml(xml)
      }
    end

    def feature_to_xml(xml)
    	@features.each{|feature| feature.to_xml(xml)}
    end
    
    def feature_parse_xml(xml)
    	xml.xpath("feature").each {|node|
        @features << Feature.parse_xml(node)
      }
    end
    
    
  end
  class FeatureHolder
  	prepend Featureable
  	
  	def initialize(*)
  	end
  	
  	def to_xml(xml)
  		feature_to_xml(xml)
  	end
  	
  	def self.parse_xml(xml)
  		temp = new
  		temp.feature_parse_xml(xml)
  		return temp
  	end
  end
end

module Game
	module Featureable

		attr_reader :features

		def initialize(name,*)
			super unless self.class.superclass == Object

			name = name.is_a?(Symbol) ? rpg : name
			@features = name.respond_to?(:features) ? name.features.map {|n|Feature.new(n)} : []
		end

		private
		def _featureable_helper(battler = nil,&block)
			features.select {|f| battler ? f.requirement.check(battler) : true }.flat_map(&block)
		end

	end

	class FeatureHolder
		include Featureable
	end
end
