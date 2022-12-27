require 'util'

class ItemAdvance < ActiveRecord::Base
	include Util
  belongs_to :advance
  has_one :client, through: :advance
  has_one :city, through: :client

  scope :order_asc, -> { order(due_date: :asc) }
  scope :order_desc, -> { order(due_date: :desc) }

  def self.items_operator(user)
    city_id = user.city_id || nil
    @clients = Client.where(city_id: city_id)
    ItemAdvance.joins(:advance).includes(:client).where("DATE(item_advances.due_date) = ? and advances.status = ? and advances.client_id in (?) ", Date.today.to_s, Advance::TypeStatus::ABERTO, @clients.ids)
  end

  def self.items_admin
    ItemAdvance.joins(:advance).includes(:client).where("DATE(item_advances.due_date) = ? and advances.status = ?", Date.today.to_s, Advance::TypeStatus::ABERTO)
  end

  def baixa_parcela(date, value)
  	last_parts = self.advance.item_advances.last
  	advance = self.advance
  	saldo = advance.balance.to_f 
    juros = (saldo * self.advance.percent) / 100
    puts ">>>>>>>>>>>>>>>> venc: #{last_parts.due_date}"
    puts ">>>>>>>>>>>>>>> saldo: #{(saldo).to_f}"
    data_pagamemto = date
    puts ">>>>>>>> Date Current: #{date.to_s} ----- #{last_parts.due_date.to_s} --- #{saldo.to_f}"
    if ((last_parts.due_date.to_s == data_pagamemto.to_s) && (saldo > 0.00))
    	puts ">>>>>>>>>>>>>>> generate_new_parts"
    	n_da_parcela = last_parts.parts
    	parcela = n_da_parcela[0..2]
    	parcela = (parcela.to_i + 1).to_s.rjust(3, '0')
      puts ">>>>>>>>>>>>>>> juros: #{juros.to_f}"
    	valor_parcela = last_parts.price
    	data = proximo_dia_util(last_parts.due_date + 1.day)
    	advance.item_advances.create!(parts: "#{parcela}/#{advance.number_parts}" , price: valor_parcela, due_date: data, dalay: 0)
    elsif ((saldo == 0.00) || (saldo < 0.00))
    	puts ">>>>>>>>>>>>>>> emprestimo quitado com sucesso."
      advance.update_attributes(status: Advance::TypeStatus::FECHADO)
    else
      puts ">>>>>>>>>>>>>>> nao faz nada."
    end
  end

  def get_next_parts
  	ItemAdvance.where("advance_id = :advance_id AND due_date > :due_date",{advance_id: self.advance_id, due_date: self.due_date}).order(:due_date).limit(1)
  end

  def self.total_diaria(city_id)
    @item_advances = ItemAdvance.joins(:client, :city).select("cities.id as id, cities.name as cidade, sum(item_advances.price) as valor, sum(item_advances.value_payment) as valor_pago").where("cities.id = ? and DATE(due_date) = ? ", city_id, Date.current.to_s ).sum(:price)    
  end

  def self.total_cobrado(city_id)
    @item_advances = ItemAdvance.joins(:client, :city).select("cities.id as id, cities.name as cidade, sum(item_advances.price) as valor, sum(item_advances.value_payment) as valor_pago").where("cities.id = ? and DATE(due_date) = ? ", city_id, Date.current ).sum(:value_payment)
  end

end
