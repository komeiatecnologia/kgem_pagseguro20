require 'test/unit'
require 'pagseguro'

class ShippingTest < Test::Unit::TestCase
	def test_return_shipping_class
		shipping = PagSeguro::Shipping.new
		assert_instance_of PagSeguro::Shipping, shipping, 'Should return shipping object'
	end

	def test_set_shipping
		PagSeguro::Shipping::TYPE.each do |name, id|
			shipping = PagSeguro::Shipping.new(:type_name => name)
			assert_equal shipping.type_id, id, 'id should be equal type_id'

			shipping = PagSeguro::Shipping.new(:type_id => id)
			assert_equal shipping.type_name, name, 'name should be equal type_name'
		end
	end

	def test_raises_when_setting_an_invalid_type_id
		shipping = PagSeguro::Shipping.new
		assert_raise(PagSeguro::Shipping::InvalidShippingTypeError){shipping.type_id = 1231}
	end

	def test_raises_when_setting_an_invalid_type_name
		shipping = PagSeguro::Shipping.new
		assert_raise(PagSeguro::Shipping::InvalidShippingTypeError){shipping.type_name = :pacman}
	end
end