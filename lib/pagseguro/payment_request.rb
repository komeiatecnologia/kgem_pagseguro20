module PagSeguro
  class PaymentRequest
    include Extensions::MassAssignment
    include Extensions::EnsureType

    attr_accessor :currency
    attr_reader :sender
    attr_reader :shipping
    attr_accessor :redirect_url
    attr_accessor :extra_amount
    attr_accessor :reference
    attr_accessor :max_age
    attr_accessor :max_uses
    attr_accessor :notification_url
    attr_accessor :abandon_url
    attr_accessor :email
    attr_accessor :token

    def items
      @items ||= Items.new
    end

    def sender=(sender)
      @sender = ensure_type(Sender, sender)
    end

    def shipping=(shipping)
      @shipping = ensure_type(Shipping, shipping)
    end

    def generate_xml
      xml = Serializer.new(self).to_params
      xml
    end

    def generate_redirect_url(xml)
      uri = URI.parse(endpoint)
      http = Net::HTTP.new(uri.host, uri.port)
      http.read_timeout = 20
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      hash_auth = {:email => PagSeguro.email, :token => PagSeguro.token}
      request = Net::HTTP::Post.new("#{uri.request_uri}/?#{to_query(hash_auth)}")
      request.initialize_http_header({'Content-Type' => 'application/xml', 'charset' => 'UTF-8'})
      request.body = xml
      response = http.request(request)
      if response.content_type =~ /xml/
        xml = Nokogiri::XML(response.body)
        if xml.css("errors").any?
          return false, Errors.get_errors(xml)
        elsif xml.css("checkout").any? && xml.css("checkout > code").any?
          return true, PagSeguro.site_url("checkout/payment.html?code=#{xml.css('checkout > code').text}")
        end
      else
        return false, Errors.get_errors('Unauthorized')
      end
    end

    private
    def before_initialize
      self.currency = "BRL"
      self.email    = PagSeguro.email
      self.token    = PagSeguro.token
    end

    def endpoint
      PagSeguro.api_url("checkout")
    end

    # CONVERTE HASH EM PARÂMETRO URL STRING
    def to_query(params)
      p = []
      params.each do |k,v|
        p << "#{k}=#{v}"
      end
      p.join "&"
    end
  end
end