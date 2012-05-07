module Jury
  module Tchk
    def type_error
      raise Exception.new, "Type error"
    end

    def is_string(s)
      return s.kind_of?(String)
    end

    def is_array_of_T(ary, type = nil, minimum_length = 0)
      is_an_array = ary.kind_of?(Array)

      if !type.nil? then
        type_error if !type.kind_of?(Class)
        all_elements_of_type = ary.all? { |e| e.kind_of?(type) }
      else
        all_elements_of_type = true
      end

      minimum_length_met = ary.size >= minimum_length

      return is_an_array && all_elements_of_type && minimum_length_met
    end
  end
end
