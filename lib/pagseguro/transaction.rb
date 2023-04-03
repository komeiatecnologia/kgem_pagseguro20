module PagSeguro
  class Transaction
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_accessor :created_at
    attr_accessor :code
    attr_accessor :reference
    attr_accessor :type_id
    attr_accessor :updated_at
    attr_reader :status
    attr_reader :payment_method
    attr_accessor :payment_link
    attr_accessor :gross_amount
    attr_accessor :discount_amount
    attr_accessor :fee_amount
    attr_accessor :net_amount
    attr_accessor :extra_amount
    attr_accessor :installments
    attr_reader :sender
    attr_reader :shipping
    attr_accessor :cancellation_source
    attr_accessor :escrow_end_date
    attr_reader :errors

    # CONSULTAR TRANSAÇÃO PELO CÓDIGO DA TRANSAÇÃO
    def self.find_by_code(transaction_code)
      response = connection_by_code("transactions", transaction_code)
      if response.content_type =~ /xml/
        xml = Nokogiri::XML(response.body)
        if xml.css("transaction").any?
          return true, load_from_xml(xml.css("transaction").first)
        elsif xml.css("errors").any?
          return false, Errors.get_errors(xml)
        end
      else
        return false, Errors.get_errors('Unauthorized')
      end
    end

    # CONSULTAR TRANSAÇÃO PELO CÓDIGO DE NOTIFICAÇÃO
    def self.find_by_notification_code(notification_code)
      response = connection_by_code("transactions/notifications", notification_code)
      if response.content_type =~ /xml/
        xml = Nokogiri::XML(response.body)
        if xml.css("transaction").any?
          return true, load_from_xml(xml.css("transaction").first)
        elsif xml.css("errors").any?
          return false, Errors.get_errors(xml)
        end
      else
        return false, Errors.get_errors('Unauthorized')
      end
    end

    # CONSULTAR HISTÓRICO DE TRANSAÇÕES
    def self.find_by_date(initial_date, final_date)
      response = connection_by_date("transactions", initial_date, final_date)
      if response.content_type =~ /xml/
        xml = Nokogiri::XML(response.body)
        if xml.css("transactionSearchResult").any?
          return true, report_transaction(xml)
        elsif xml.css("errors").any?
          return false, Errors.get_errors(xml)
        end
      else
        return false, Errors.get_errors('Unauthorized')
      end
    end

    # CONSULTAR TRANSAÇÕES ABANDONADAS
    def self.find_abandoned(initial_date, final_date)
      response = connection_by_date("transactions/abandoned", initial_date, final_date)
      if response.content_type =~ /xml/
        xml = Nokogiri::XML(response.body)
        if xml.css("transactionSearchResult").any?
          return true, report_transaction(xml)
        elsif xml.css("errors").any?
          return false, Errors.get_errors(xml)
        end
      else
        return false, Errors.get_errors('Unauthorized')
      end
    end

    def self.connection_by_code(url, code)
      uri = URI.parse(PagSeguro.api_url(url))
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 20
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      body = {:email => PagSeguro.email, :token => PagSeguro.token}
      request = Net::HTTP::Get.new("#{uri.request_uri}/#{code}?#{to_query(body)}")
      response = http.request(request)
    end

    def self.connection_by_date(url, initial_date, final_date)
      uri = URI.parse(PagSeguro.api_url(url))
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 20
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      body = {:initialDate => initial_date.strftime("%Y-%m-%dT%H:%M"), :finalDate => final_date.strftime("%Y-%m-%dT%H:%M"), :email => PagSeguro.email, :token => PagSeguro.token}
      request = Net::HTTP::Get.new("#{uri.request_uri}/?#{to_query(body)}")
      response = http.request(request)
      response
    end

    # CONVERTE HASH EM PARÂMETRO URL STRING
    def self.to_query(params)
      p = []
      params.each do |k,v|
        p << "#{k}=#{v}"
      end
      p.join "&"
    end

    # JOGA O RETORNO DA CONSULTA POR PERÍODO EM UM ARRAY
    def self.report_transaction(xml)
      report_transactions = []
      if xml.css("transactions").any? && xml.css("transactions > transaction").any?
        xml.css("transactions > transaction").each do |transaction|
          report_transactions << load_from_xml(transaction)
        end
        report_transactions
      else
        nil
      end
    end

    def self.load_from_xml(xml)
      new Serializer.new(xml).serialize
    end

    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    def items
      @items ||= Items.new
    end

    def items=(_items)
      _items.each {|item| items << item }
    end

    def payment_method=(payment_method)
      @payment_method = ensure_type(PaymentMethod, payment_method)
    end

    def status=(status)
      @status = ensure_type(PaymentStatus, status)
    end
  end
end