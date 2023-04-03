module PagSeguro
  class PaymentRequest
    class Serializer
      attr_reader :payment_request

      def initialize(payment_request)
        @payment_request = payment_request
      end

      def to_params
        xml = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?><checkout>'
        xml << "<receiverEmail>#{PagSeguro.receiver_email}</receiverEmail>" if PagSeguro.receiver_email
        # MOEDA
        xml << "<currency>#{payment_request.currency}</currency>" if payment_request.currency
        # CÓDIGO DO PEDIDO
        xml << "<reference>#{payment_request.reference}</reference>" if payment_request.reference
        # VALOR EXTRA DESCONTO/ACRÉSCIMO
        xml << "<extraAmount>#{to_amount(payment_request.extra_amount)}</extraAmount>" if payment_request.extra_amount
        # REDIRECIONAMENTO
        xml << "<redirectURL>#{payment_request.redirect_url}</redirectURL>" if payment_request.redirect_url
        # URL DE NOTIFICAÇÃO NO SISTEMA
        xml << "<notificationURL>#{payment_request.notification_url}</notificationURL>" if payment_request.notification_url
        xml << "<abandonURL>#{payment_request.abandon_url}</abandonURL>" if payment_request.abandon_url
        # NÚMERO MÁXIMO DE USOS PARA O CÓDIGO DE PAGAMENTO
        xml << "<maxUses>#{payment_request.max_uses}</maxUses>" if payment_request.max_uses
        # PRAZO DE VALIDADE DO CÓDIGO DE PAGAMENTO
        xml << "<maxAge>#{payment_request.max_age}</maxAge>" if payment_request.max_age
        # ITEMS DO PEDIDO
        if payment_request.items.size > 0
          xml << "<items>"
          payment_request.items.each do |item|
            xml << serialize_item(item)
          end
          xml << "</items>"
        end
        # DADOS DO COMPRADOR
        if payment_request.sender
          xml << serialize_sender(payment_request.sender)
        end
        # DADOS DO FRETE E ENDEREÇO DE ENTREGA
        if payment_request.shipping
          xml << serialize_shipping(payment_request.shipping)
        end
        xml << '</checkout>'
        xml
      end

      private
      def params
        @params ||= {}
      end

      def serialize_item(item)
        xml_item = '<item>'
        xml_item << "<id>#{item.id}</id>" if item.id
        xml_item << "<description>#{item.description}</description>" if item.description
        xml_item << "<amount>#{to_amount(item.amount)}</amount>" if item.amount
        xml_item << "<quantity>#{item.quantity}</quantity>" if item.quantity
        xml_item << "<shippingCost>#{to_amount(item.shipping_cost)}</shippingCost>" if item.shipping_cost
        xml_item << "<weight>#{item.weight.to_i}</weight>" if item.weight
        xml_item << '</item>'
        xml_item
      end

      def serialize_sender(sender)
        xml_sender = '<sender>'
        xml_sender << "<name>#{sender.name}</name>" if sender.name && sender.name[' '] != nil
        xml_sender << "<email>#{sender.email}</email>" if sender.email
        if sender.phone
          xml_sender << serialize_phone(sender.phone)
        end
        xml_sender << '</sender>'
        xml_sender
      end

      def serialize_phone(phone)
        xml_phone = '<phone>'
        xml_phone << "<areaCode>#{phone.area_code}</areaCode>" if phone.area_code
        xml_phone << "<number>#{phone.number.gsub('-', '')}</number>" if phone.number && phone.number.size >= 7
        xml_phone << '</phone>'
        xml_phone
      end

      def serialize_shipping(shipping)
        xml_shipping = '<shipping>'
        xml_shipping << "<type>#{shipping.type_id}</type>" if shipping.type_id
        xml_shipping << "<cost>#{to_amount(shipping.cost)}</cost>" if shipping.cost
        if shipping.address
          xml_shipping << serialize_address(shipping.address)
        end
        xml_shipping << '</shipping>'
      end

      def serialize_address(address)
        xml_address = '<address>'
        xml_address << "<street>#{address.street}</street>" if address.street
        xml_address << "<number>#{address.number}</number>" if address.number
        xml_address << "<complement>#{address.complement}</complement>" if address.complement
        xml_address << "<district>#{address.district}</district>" if address.district
        xml_address << "<postalCode>#{address.postal_code}</postalCode>" if address.postal_code
        xml_address << "<city>#{address.city}</city>" if address.city
        xml_address << "<state>#{address.state}</state>" if address.state
        xml_address << "<country>#{address.country}</country>" if address.country
        xml_address << '</address>'
        xml_address
      end

      def to_amount(amount)
        "%.2f" % BigDecimal(amount.to_s).round(2).to_s("F") if amount
      end
    end
  end
end