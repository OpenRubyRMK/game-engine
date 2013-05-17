module RPG
  class Requirement
    def check(battler)
      return _check(battler).all?
    end

    def to_xml(xml)

    end

    private

    def check_array(var,battler_attr)
      pr = proc{|v| battler_attr.include?(v) }
      (var[:all].nil? || var[:all].all?(&pr)) &&
      (var[:any].nil? || var[:any].empty? || var[:any].any?(&pr)) &&
      (var[:one].nil? || var[:one].empty? || var[:one].one?(&pr)) &&
      (var[:none].nil? || var[:none].none?(&pr))
    end

    def check_array_level(var,battler_attr)
      pr = proc{|v,l| battler_attr.include?(v) && battler_attr[v].level >= l }
      (var[:all].nil? || var[:all].all?(&pr)) &&
      (var[:any].nil? || var[:any].empty? || var[:any].any?(&pr)) &&
      (var[:one].nil? || var[:one].empty? || var[:one].one?(&pr)) &&
      (var[:none].nil? || var[:none].none?(&pr))
    end

    def _check(battler)
      []
    end

    def _to_xml_array(xml,value,name,name_plural)
      
      [:all,:any,:one,:none].each {|type|
        xml.send(name_plural,:type => type) {
          value[type].each{|k,l|
            h = {:name => k}
            h[:level] = l if l
            xml.send(name,h)
          }
        } if value[type] && !value[type].empty?
      }
    end

  end
end