require 'test/unit'
require 'pagseguro'

class ItemTest < Test::Unit::TestCase
	def test_return_item_class
		item = PagSeguro::Item.new
		assert_instance_of PagSeguro::Item, item, 'Should return item object'
	end

	def test_default_values
		item = PagSeguro::Item.new
		assert_equal 1, item.quantity, 'Should be 1 quantity'
		assert_equal 0, item.weight, 'Should be 0 weight'
	end
end