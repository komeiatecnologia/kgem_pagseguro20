# -*- encoding: utf-8 -*-
module PagSeguro
  class PaymentMethod
    include Extensions::MassAssignment

    TYPES = {
      "1" => :credit_card,
      "2" => :boleto,
      "3" => :online_transfer,
      "4" => :balance,
      "5" => :oi_paggo,
      "7" => :direct_deposit
    }.freeze

    attr_accessor :code
    attr_accessor :type_id

    TYPES.each do |id, type|
      define_method "#{type}?" do
        type_id.to_s == id
      end
    end

    def type
      TYPES.fetch(type_id.to_s) { raise "PagSeguro::PaymentMethod#type_id isn't mapped" }
    end

    def description
      case self.code
      when "101"
        "Cartão de crédito Visa"
      when "102"
        "Cartão de crédito MasterCard"
      when "103"
        "Cartão de crédito American Express"
      when "104"
        "Cartão de crédito Diners"
      when "105"
        "Cartão de crédito Hipercard"
      when "106"
        "Cartão de crédito Aura"
      when "107"
        "Cartão de crédito Elo"
      when "108"
        "Cartão de crédito PLENOCard"
      when "109"
        "Cartão de crédito PersonalCard"
      when "110"
        "Cartão de crédito JCB"
      when "111"
        "Cartão de crédito Discover"
      when "112"
        "Cartão de crédito BrasilCard"
      when "113"
        "Cartão de crédito FORTBRASIL"
      when "114"
        "Cartão de crédito CARDBAN"
      when "115"
        "Cartão de crédito VALECARD"
      when "116"
        "Cartão de crédito Cabal"
      when "117"
        "Cartão de crédito Mais!"
      when "118"
        "Cartão de crédito Avista"
      when "119"
        "Cartão de crédito GRANDCARD"
      when "120"
        "Cartão de crédito SOROCRED"
      when "201"
        "Boleto Bradesco"
      when "202"
        "Boleto Santander"
      when "301"
        "Débito online Bradesco"
      when "302"
        "Débito online Itaú"
      when "303"
        "Débito online Unibanco"
      when "304"
        "Débito online Banco do Brasil"
      when "305"
        "Débito online Banco Real"
      when "306"
        "Débito online Banrisul"
      when "307"
        "Débito online HSBC"
      when "401"
        "Saldo PagSeguro"
      when "501"
        "Oi Paggo"
      when "701"
        "Depósito em conta Banco do Brasil"
      end
    end
  end
end