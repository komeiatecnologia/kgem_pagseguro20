require 'test/unit'
require 'pagseguro'

class AddressTest < Test::Unit::TestCase
	def test_return_address_class
		address = PagSeguro::Address.new
		assert_instance_of PagSeguro::Address, address, 'Should return address object'
	end

	def test_default_values
		address = PagSeguro::Address.new
		assert_equal 'BRA', address.country, 'Should be BRA for country'
	end
end