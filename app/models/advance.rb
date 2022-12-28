require 'util'
class Advance < ActiveRecord::Base
	include Util
  belongs_to :client
  has_one :city, through: :client
  has_many :item_advances, dependent: :delete_all
  validates :client_id, presence: true
  validates :date_advance, presence: true
  validates :price, presence: true
  validates :percent, presence: true
  validates :number_parts, presence: true

  after_create :generate_item
  after_create :generate_current_account
  
  scope :order_asc, -> { includes(:client, :city).order(date_advance: :asc) }
  scope :order_desc, -> { includes(:client, :city).order(date_advance: :desc) }
  scope :advances_open, -> { where(status: TypeStatus::ABERTO) }

  module TypeStatus
    ABERTO = 0
    FECHADO = 1
  end

  def name_status
    case self.status
      when 0  then "Aberto"
      when 1  then "Fechado"
    else "Nao Definido"
    end
  end

  def generate_item
    # Nao da certo deletar as parcelas quando alterar os dados do emprestimo
    # pq quando for atulizar o status de quitacao pode entrar na validacao

    # verifica se tem parcela paga, se tiver nao deixa gerar novas parcelas
    # if has_paid? == false
    #   ">>>>>>>>>>>>>>>> nao existe parcelas pagas"
    #   self.item_advances.destroy_all 
    # end

  	valor_parcela = self.price / self.number_parts
  	n_da_parcela = 1
  	data = self.date_advance + 1.day
  	ActiveRecord::Base.transaction do
  		self.number_parts.times.each do |p|
  		  data = proximo_dia_util(data)
        parcela = n_da_parcela.to_s.rjust(3, '0')
  	  	self.item_advances.create!(parts: "#{parcela}/#{self.number_parts}" , price: valor_parcela, due_date: data, dalay: 0)
  	  	data = data + 1.day
  	  	n_da_parcela = n_da_parcela + 1
    	end
    end
  end

  def generate_current_account
    type_launche = CurrentAccount::TypeLaunche::DEBITO
    cost = Cost::TypeCost::PAGAMENTO_EMPRESTIMO
    city = self.city
    price = self.price - self.lucre
    historic = "PGTO DE EMPRESTIMO - #{self.client.name}"
    CurrentAccount.create!(type_launche: type_launche , city_id: city.id, cost_id: cost, date_ocurrence: self.date_advance, price: price, historic: historic )
  end

  def update_and_cache(params, old_value)
    ActiveRecord::Base.transaction do
      update!(params)
      #Creditar o Estorno
      CurrentAccount.create!(
        type_launche: CurrentAccount::TypeLaunche::CREDITO, 
        city_id: city.id, 
        cost_id: Cost::TypeCost::PAGAMENTO_EMPRESTIMO,
        date_ocurrence: date_advance, 
        price: old_value, 
        historic: "ESTORNO PGTO DE EMPRESTIMO - #{self.client.name}" 
      )
      # Debita novo valor ao caixa
      CurrentAccount.create!(
        type_launche: CurrentAccount::TypeLaunche::DEBITO, 
        city_id: city.id, 
        cost_id: Cost::TypeCost::PAGAMENTO_EMPRESTIMO,
        date_ocurrence: self.date_advance, 
        price: price - lucre, 
        historic: "PGTO DE EMPRESTIMO - #{self.client.name}" 
      )
      true
    end
  rescue
    puts "Oops. We tried to do an invalid operation!"
  end

  def balance
    (self.price - self.item_advances.sum(:value_payment)).to_f
  end

  def payd
    self.item_advances.sum(:value_payment).to_f
  end

  def lucre
    (self.price * self.percent) / 100
  end

  def self.total_lucre
    Advance.advances_open.sum("(price * percent) / 100")
  end

  def self.total_balance
    Advance.advances_open.sum(:price) - Advance.advances_open.joins(:item_advances).sum('item_advances.value_payment')
  end

  def recalculation
    #inicializando as variaveis
    percent = self.percent
    number_parts = self.number_parts
    price = self.balance + ((self.balance * percent) / 100)
    client_id = self.client_id
    date_advance = Date.current

    ActiveRecord::Base.transaction do
      self.update(status: TypeStatus::FECHADO)
      Advance.create!(client_id: client_id, date_advance: date_advance, price: price, percent: percent, number_parts: number_parts, status: TypeStatus::ABERTO)
      puts ">>>>>>>>>>>>>>>>> recalculo efetuado com sucesso."
    end
    
  end

  def has_paid?
    item_advances.where.not(date_payment: nil).present?
  end
end
