module PagSeguro
	class Address
		include Extensions::MassAssignment
    
    attr_accessor :street
    attr_accessor :number
    attr_accessor :complement
    attr_accessor :district
    attr_accessor :city
    attr_accessor :state
    attr_accessor :postal_code
    attr_accessor :country

    private
    def before_initialize
      self.country = "BRA"
    end
	end
end