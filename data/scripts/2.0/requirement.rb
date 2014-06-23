module RPG
  class Requirement
    def check(battler)
      return _check(battler).all?
    end

    def to_xml(xml)

    end
    
    def parse_xml(xml)
    
    end
    
    private
    def init_check(lev = false)
      d = lev ? {} : []
      {:all => d.dup, :any => d.dup, :one => d.dup, :none => d.dup}
    end
    
    def internal_check(var, &pr)
      Array(var[:all]).all?(&pr) &&
      (Array(var[:any]).empty? || var[:any].any?(&pr)) &&
      (Array(var[:one]).empty? || var[:one].one?(&pr)) &&
      Array(var[:none]).none?(&pr)
    end
    def check_array(var,battler_attr)
      internal_check(var) {|v| battler_attr.include?(v) }
    end

    def check_array_level(var,battler_attr)
      internal_check(var) {|v,l| battler_attr.include?(v) && battler_attr[v].level >= l }
    end

    def _check(battler)
      []
    end
    
    def _parse_xml(xml,val,name,plural_name,levl = false)
      pr = levl ? proc {|n| [n[:name].to_sym, n[:level].to_i] } : proc {|n| n[:name].to_sym }
      
      xml.xpath(plural_name).each {|node|
        h = node.xpath(name).map(&pr)
        h = h.to_h if levl
        val[node[:type].to_sym] = h
      }
    
    end
      
    def _to_xml_array(xml,value,name,name_plural)
      
      [:all,:any,:one,:none].each {|type|
        xml.send(name_plural,:type => type) {
          value[type].each{|args|
            xml.send(name,Array(args).zip([:name,:level]).map(&:reverse).to_h)
          }
        } if value[type] && !value[type].empty?
      }
    end

  end
end
