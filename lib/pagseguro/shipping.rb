module PagSeguro
  class Shipping
    TYPE = {
      :pac => 1,
      :sedex => 2,
      :not_specified => 3
    }

    InvalidShippingTypeError = Class.new(StandardError)

    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_reader :type_id
    attr_reader :type_name
    attr_reader :address
    attr_accessor :cost

    def address=(address)
      @address = ensure_type(Address, address)
    end

    def type_name=(type_name)
      type_name = type_name.to_sym
      @type_id = TYPE.fetch(type_name) {
        raise InvalidShippingTypeError, "invalid #{type_name.inspect} type name"
      }
      @type_name = type_name
    end

    def type_id=(id)
      type_id = id.to_i

      raise InvalidShippingTypeError,
        "invalid #{id.inspect} type id" unless TYPE.value?(type_id)

      @type_id = type_id
      @type_name = return_shipping_name_by_id(type_id)
    end

    def return_shipping_name_by_id(type_id)
      name = ''
      TYPE.each do |key, value|
        name = key if value == type_id
      end
      name
    end
  end
end