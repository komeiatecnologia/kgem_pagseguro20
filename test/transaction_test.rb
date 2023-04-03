require 'test/unit'
require 'pagseguro'

class TransactionTest < Test::Unit::TestCase
	def test_to_query_method
		hash = {:email => 'DEFAULT_EMAIL', :token => 'DEFAULT_TOKEN'}
		str = PagSeguro::Transaction.to_query(hash)
		assert_equal 'email=DEFAULT_EMAIL&token=DEFAULT_TOKEN', str, 'Should return url string'
	end

	def test_report_transaction_method
		xml = File.read("./test/xml/transaction_find_abandoned_result.xml")
		xml = Nokogiri::XML(xml)
		reports = PagSeguro::Transaction.report_transaction(xml)
		assert_equal 3, reports.size, 'Should be 3 transactions'
	end

	def test_load_from_xml_method
		xml = File.read("./test/xml/transaction_find_by_code_result.xml")
		xml = Nokogiri::XML(xml)
		transaction = PagSeguro::Transaction.load_from_xml(xml)
		assert_instance_of PagSeguro::Sender, transaction.sender, 'Shold be PagSeguro::Sender'
		assert_instance_of PagSeguro::Shipping, transaction.shipping, 'Shold be PagSeguro::Shipping'
		assert_instance_of PagSeguro::Items, transaction.items, 'Should be PagSeguro::Items'
		assert_instance_of PagSeguro::PaymentMethod, transaction.payment_method, 'Should be PagSeguro::PaymentMethod'
		assert_instance_of PagSeguro::PaymentStatus, transaction.status, 'Should be PagSeguro::PaymentStatus'
		assert_equal 1, transaction.items.size, 'Should be 1 items'
	end

	def test_return_transaction_status
		xml = File.read("./test/xml/transaction_find_by_code_result.xml")
		xml = Nokogiri::XML(xml)
		transaction = PagSeguro::Transaction.load_from_xml(xml)
		assert_equal '1', transaction.status.id, 'Should return 1 code status'
		assert_equal 'Aguardando Pagamento', transaction.status.description, 'Should return Aguardando Pagamento in status description'
	end

	def test_return_transaction_address
		xml = File.read("./test/xml/transaction_find_by_code_result.xml")
		xml = Nokogiri::XML(xml)
		transaction = PagSeguro::Transaction.load_from_xml(xml)
		assert_equal 'AVENIDA JUSCELINO KUBITSCHEK', transaction.shipping.address.street, 'Should be AVENIDA JUSCELINO KUBITSCHEK for street'
		assert_equal '1234', transaction.shipping.address.number, 'Should be 1234 for number'
		assert_equal 'Vila Ipiranga', transaction.shipping.address.district, 'Should be Vila Ipiranga for district'
		assert_equal 'Casa', transaction.shipping.address.complement, 'Should be BRA for complement'
		assert_equal 'LONDRINA', transaction.shipping.address.city, 'Should be LONDRINA for city'
		assert_equal 'PR', transaction.shipping.address.state, 'Should be PR for state'
		assert_equal 'BRA', transaction.shipping.address.country, 'Should be BRA for country'
		assert_equal '86010540', transaction.shipping.address.postal_code, 'Should be 86010540 for postalCode'
	end
end