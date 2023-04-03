require 'test/unit'
require 'pagseguro'

class SenderTest < Test::Unit::TestCase
	def test_return_sender_class
		sender = PagSeguro::Sender.new
		assert_instance_of PagSeguro::Sender, sender, 'Should return sender object'
	end
end