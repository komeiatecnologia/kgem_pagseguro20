require 'test/unit'
require 'pagseguro'

class PhoneTest < Test::Unit::TestCase
	def test_return_phone_class
		phone = PagSeguro::Phone.new
		assert_instance_of PagSeguro::Phone, phone, 'Should return phone object'
	end
end