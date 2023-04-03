module PagSeguro
  class Sender
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_reader :phone
    attr_accessor :name
    attr_accessor :email
    attr_accessor :cpf

    def phone=(phone)
      @phone = ensure_type(Phone, phone)
    end
  end
end