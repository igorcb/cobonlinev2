require 'util'
class Advance < ApplicationRecord
  include Util
  belongs_to :client
  has_one :city, through: :client
  has_many :item_advances, dependent: :delete_all
  validates :date_advance, presence: true
  validates :price, presence: true
  validates :percent, presence: true
  validates :number_parts, presence: true

  after_create :generate_item
  after_create :generate_current_account

  before_destroy :reversal_current_account

  scope :order_asc, -> { includes(:client, :city).order(date_advance: :asc) }
  scope :order_desc, -> { includes(:client, :city).order(date_advance: :desc) }
  scope :advances_open, -> { where(status: TypeStatus::ABERTO) }

  module TypeStatus
    ABERTO = 0
    FECHADO = 1
  end

  def name_status
    case status
    when 0  then 'Aberto'
    when 1  then 'Fechado'
    else 'Nao Definido'
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

    valor_parcela = price / number_parts
    n_da_parcela = 1
    data = date_advance + 1.day
    ActiveRecord::Base.transaction do
      number_parts.times.each do |_p|
        data = proximo_dia_util(data)
        parcela = n_da_parcela.to_s.rjust(3, '0')
        item_advances.create!(parts: "#{parcela}/#{number_parts}", price: valor_parcela, due_date: data)
        data += 1.day
        n_da_parcela += 1
      end
    end
  end

  def generate_current_account
    type_launche = CurrentAccount::TypeLaunche::DEBITO
    cost = Cost::TypeCost::PAGAMENTO_EMPRESTIMO
    city = self.city
    price = self.price - lucre
    historic = "PGTO DE EMPRESTIMO - #{client.name}"
    CurrentAccount.create!(type_launche: type_launche, city_id: city.id, cost_id: cost,
                           date_ocurrence: date_advance, price: price, historic: historic)
  end

  def reversal_current_account
    CurrentAccount.create!(
      type_launche: CurrentAccount::TypeLaunche::CREDITO,
      city_id: city.id,
      cost_id: Cost::TypeCost::PAGAMENTO_EMPRESTIMO,
      date_ocurrence: date_advance,
      price: price - lucre,
      historic: "ESTORNO PGTO DE EMPRESTIMO - #{client.name}"
    )
  end

  def update_and_cache(params, old_value)
    ActiveRecord::Base.transaction do
      update!(params)
      # Creditar o Estorno
      CurrentAccount.create!(
        type_launche: CurrentAccount::TypeLaunche::CREDITO,
        city_id: city.id,
        cost_id: Cost::TypeCost::PAGAMENTO_EMPRESTIMO,
        date_ocurrence: date_advance,
        price: old_value,
        historic: "ESTORNO PGTO DE EMPRESTIMO - #{client.name}"
      )
      # Debita novo valor ao caixa
      CurrentAccount.create!(
        type_launche: CurrentAccount::TypeLaunche::DEBITO,
        city_id: city.id,
        cost_id: Cost::TypeCost::PAGAMENTO_EMPRESTIMO,
        date_ocurrence: date_advance,
        price: price - lucre,
        historic: "PGTO DE EMPRESTIMO - #{client.name}"
      )
      true
    end
  rescue StandardError
    Rails.logger.debug 'Oops. We tried to do an invalid operation!'
  end

  def balance
    (price - item_advances.sum(:value_payment)).to_f
  end

  def payd
    item_advances.sum(:value_payment).to_f
  end

  def lucre
    (price * percent) / 100
  end

  def self.total_lucre
    Advance.advances_open.sum('(price * percent) / 100')
  end

  def self.total_balance
    Advance.advances_open.sum(:price) - Advance.advances_open.joins(:item_advances).sum('item_advances.value_payment')
  end

  def delay
    item_advances.sum('price - value_payment').to_f
  end

  def recalculation
    # inicializando as variaveis
    percent = self.percent
    number_parts = self.number_parts
    price = balance + ((balance * percent) / 100)
    client_id = self.client_id
    date_advance = Date.current

    ActiveRecord::Base.transaction do
      update(status: TypeStatus::FECHADO)
      Advance.create!(client_id: client_id, date_advance: date_advance, price: price, percent: percent,
                      number_parts: number_parts, status: TypeStatus::ABERTO)
      Rails.logger.debug '>>>>>>>>>>>>>>>>> recalculo efetuado com sucesso.'
    end
  end

  def paid?
    item_advances.where.not(date_payment: nil).present?
  end
end
