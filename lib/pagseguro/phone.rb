module PagSeguro
  class Phone
    include Extensions::MassAssignment

    attr_accessor :area_code
    attr_accessor :number
  end
end