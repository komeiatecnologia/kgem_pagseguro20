require 'rubygems'
require 'nokogiri'

require 'bigdecimal'
require 'forwardable'
require 'time'
require 'uri'
require 'net/https'

require 'pagseguro/extensions/mass_assignment'
require 'pagseguro/extensions/ensure_type'
require 'pagseguro/address'
require 'pagseguro/item'
require 'pagseguro/items'
require 'pagseguro/payment_method'
require 'pagseguro/payment_request'
require 'pagseguro/payment_request/serializer'
require 'pagseguro/payment_status'
require 'pagseguro/phone'
require 'pagseguro/sender'
require 'pagseguro/shipping'
require 'pagseguro/transaction'
require 'pagseguro/transaction/serializer'
require 'pagseguro/errors'

module PagSeguro
	class << self
    attr_accessor :email
    attr_accessor :receiver_email
    attr_accessor :token
    attr_accessor :encoding
    attr_accessor :environment
  end

  self.encoding = "UTF-8"
  self.environment = :production

  def self.uris
    @uris ||= {
      :production => {
        :api => "https://ws.pagseguro.uol.com.br/v2",
        :site => "https://pagseguro.uol.com.br/v2"
      }
    }
  end

  def self.root_uri(type)
    root = uris.fetch(environment.to_sym) { raise InvalidEnvironmentError }
    root[type.to_sym]
  end

  # Set the global configuration.
  #
  #   PagSeguro.configure do |config|
  #     config.email = "john@example.com"
  #     config.token = "abc"
  #   end
  #
  def self.configure(&block)
    yield self
  end

  def self.api_url(path)
    File.join(root_uri(:api), path)
  end

  def self.site_url(path)
    File.join(root_uri(:site), path)
  end
end