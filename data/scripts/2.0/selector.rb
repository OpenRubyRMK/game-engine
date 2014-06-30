module RPG
  class Selector
    def check(item)
      temp = _check(item).compact
      return !temp.empty? && temp.all?
    end

    def _check(item)
      []
    end

    def to_xml(xml)

    end

    private

    def check_value(var,item_attr)
    return nil unless [:all,:any,:one,:none].any? {|type| _present?(var[type])}
      pr = proc{|v| item_attr  == v }
      (var[:all].nil? || var[:all].all?(&pr)) &&
      (var[:any].nil? || var[:any].empty? || var[:any].any?(&pr)) &&
      (var[:one].nil? || var[:one].empty? || var[:one].one?(&pr)) &&
      (var[:none].nil? || var[:none].none?(&pr))
    end

    def _to_xml_value(xml,value,name,name_plural)
      [:all,:any,:one,:none].each {|type|
        xml.send(name_plural,:type => type) {
          value[type].each{|k|
            xml.send(name,:name => k)
          }
        } if value[type] && !value[type].empty?
      }
    end

    def _present?(var)
      (!var.nil? && !var.empty?)
    end
  end
end
