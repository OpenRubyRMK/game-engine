require "r18n-desktop"
include R18n::Helpers
module Translation
	def translation(*names)
		attr_writer *names
		names.each do |n|
			define_method(n) do |*params| #define_method
				temp = t
				self.class.name.split("::").each{|s| temp = temp[s]}
				temp[n][instance_variable_get("@#{n}".to_sym), *params] #instance_variable_get
			end
		end
	end
end