require_relative "levelable"
require_relative "mastery"

module RPG
  module Levelable
    class Level
      attr_accessor :mastery_rate
      chain "MasteryInfluence" do
        def initialize(*)
          super
          @mastery_rate = Hash.new(1.0)
        end
        
        def _to_xml(xml)
          super
          xml.mastery_rate{
            @mastery_rate.each{|k,v| xml.mastery(v,:name=>k) }
          }
        end
  
        def _parse_xml(level)
          super
          level.xpath("mastery_rate/mastery").each {|node|
            @mastery_rate[node[:name].to_sym] = node.text.to_f
          }
        end
      end
    end
  end
end