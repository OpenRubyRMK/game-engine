require_relative "element"


module RPG
  class Damage
    attr_accessor :elements
    attr_accessor :type
    attr_accessor :variance
    
    def initialize
      @elements = []
    end
    
    def to_xml(xml)
      xml.damage(:type => @type,:variance => @variance) {
        xml.elements {
          @elements.each{ |el|
            xml.element(:type => el)
          }
        }
      }
    end
  end
end