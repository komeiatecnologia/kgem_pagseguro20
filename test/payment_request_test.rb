require 'test/unit'
require 'pagseguro'

class PaymentRequestTest < Test::Unit::TestCase
	def test_return_payment_request_class
		payment = PagSeguro::PaymentRequest.new
		assert_instance_of PagSeguro::PaymentRequest, payment, 'Should return PagSeguro::PaymentRequest object'
	end

	def test_set_sender
    sender = PagSeguro::Sender.new
    payment = PagSeguro::PaymentRequest.new(:sender => sender)
    assert_instance_of PagSeguro::Sender, payment.sender, 'Should return sender object in payment object'
  end

  def test_set_items
  	payment = PagSeguro::PaymentRequest.new
  	assert_instance_of PagSeguro::Items, payment.items, 'Should return items object in payment object'
  end

  def test_default_currency
  	payment = PagSeguro::PaymentRequest.new
  	assert_equal 'BRL', payment.currency, 'Should return BRL value in currency field'
  end

  def test_email
  	PagSeguro.email = 'DEFAULT_EMAIL'
  	assert_equal 'foo', PagSeguro::PaymentRequest.new(:email => 'foo').email, 'Should return the email set in the constructor'
  	assert_equal 'DEFAULT_EMAIL', PagSeguro::PaymentRequest.new.email, 'Should return default email'
  end

  def test_token
  	PagSeguro.token = 'DEFAULT_TOKEN'
  	assert_equal 'foo', PagSeguro::PaymentRequest.new(:token => 'foo').token, 'Should return the token set in the constructor'
  	assert_equal 'DEFAULT_TOKEN', PagSeguro::PaymentRequest.new.token, 'Should return default token'
  end

  def test_serializes_payment_request_and_return_xml
  	payment = PagSeguro::PaymentRequest.new
  	payment.items << {
		  :id => 1234,
		  :description => %[Televisão 19" Sony],
		  :amount => 459.50,
		  :weight => 0
		}
		payment.reference = "REF1234"
		payment.sender = {
		  :name => "Komeia Interativa",
		  :email => "teste@gmail.com",
		  :phone => {
		    :area_code => 11,
		    :number => "1234-5678"
		  }
		}
		payment.shipping = {
		  :type_name => "sedex",
		  :address => {
		    :street => "R. Teste",
		    :number => 1421,
		    :complement => "Sala 213",
		    :city => "Londrina",
		    :state => "PR",
		    :district => "Centro"
		  }
		}
  	assert_equal '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><checkout><currency>BRL</currency><reference>REF1234</reference><items><item><id>1234</id><description>Televisão 19" Sony</description><amount>459.50</amount><quantity>1</quantity><weight>0</weight></item></items><sender><name>Komeia Interativa</name><email>teste@gmail.com</email><phone><areaCode>11</areaCode><number>12345678</number></phone></sender><shipping><type>2</type><address><street>R. Teste</street><number>1421</number><complement>Sala 213</complement><district>Centro</district><city>Londrina</city><state>PR</state><country>BRA</country></address></shipping></checkout>', payment.generate_xml, 'Should return xml'
  end

  def test_invalid_authenticate
  	PagSeguro.email = 'DEFAULT_EMAIL'
  	PagSeguro.token = 'DEFAULT_TOKEN'
  	payment = PagSeguro::PaymentRequest.new
  	payment.items << {
		  :id => 1234,
		  :description => %[Televisão 19" Sony],
		  :amount => 459.50,
		  :weight => 0
		}
		payment.reference = "REF1234"
		payment.sender = {
		  :name => "Komeia Interativa",
		  :email => "teste@gmail.com",
		  :phone => {
		    :area_code => 11,
		    :number => "12345678"
		  }
		}
		payment.shipping = {
		  :type_name => "sedex",
		  :cost => 10.00,
		  :address => {
		    :street => "R. Teste",
		    :number => 1421,
		    :complement => "Sala 213",
		    :city => "Londrina",
		    :state => "PR",
		    :district => "Centro"
		  }
		}
		xml = payment.generate_xml
		success, response = payment.generate_redirect_url(xml)
		assert_equal 'Não Autorizado', response[0], 'Should return Não Autorizado message'
		assert_equal false, success, 'Should return false'
  end

  def test_success_payment_code
		xml = File.read("./test/xml/payment_code_success.xml")
		xml = Nokogiri::XML(xml)
		assert_equal '8CF4BE7DCECEF0F004A6DFA0A8243412', xml.css('checkout > code').text, 'Should be 8CF4BE7DCECEF0F004A6DFA0A8243412'
  end

  def test_there_errors
  	xml = File.read("./test/xml/errors.xml")
  	xml = Nokogiri::XML(xml)
  	assert_equal true, xml.css('errors').any?, 'Should be true'
  end
end