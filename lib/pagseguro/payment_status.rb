module PagSeguro
  class PaymentStatus
    STATUSES = {
      "0" => :initiated,
      "1" => :waiting_payment,
      "2" => :in_analysis,
      "3" => :paid,
      "4" => :available,
      "5" => :in_dispute,
      "6" => :refunded,
      "7" => :cancelled,
    }.freeze

    attr_reader :id

    def initialize(id)
      @id = id
    end

    STATUSES.each do |id, _status|
      define_method "#{_status}?" do
        _status == status
      end
    end

    def status
      STATUSES.fetch(id.to_s) { raise "PagSeguro::PaymentStatus#id isn't mapped" }
    end

    def description
      case self.id.to_i
      when 1
        'Aguardando Pagamento'
      when 2
        'Em Análise'
      when 3
        'Paga'
      when 4
        'Disponível'
      when 5
        'Em disputa'
      when 6
        'Devolvida'
      when 7
        'Cancelada'
      end
    end
  end
end