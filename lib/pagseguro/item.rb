module PagSeguro
  class Item
    include Extensions::MassAssignment

    attr_accessor :id
    attr_accessor :description
    attr_accessor :quantity
    attr_accessor :amount
    attr_accessor :weight
    attr_accessor :shipping_cost

    private
    def before_initialize
      self.quantity = 1
      self.weight = 0
    end
  end
end