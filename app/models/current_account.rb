class CurrentAccount < ApplicationRecord
  belongs_to :city
  belongs_to :cost

  validates :date_ocurrence, presence: true
  validates :type_launche, presence: true
  validates :price, presence: true

  scope :total_creditos, -> { where(type_launche: TypeLaunche::CREDITO) }
  scope :total_debitos, -> { where(type_launche: TypeLaunche::DEBITO) }

  module TypeLaunche
    DEBITO = -1
    CREDITO = 1
  end

  module TypeCost
    PAGAMENTO_EMPRESTIMO = 1
    RECEBIMENTO_COBRANCA = 2
  end

  def credito_debito
    case type_launche
    when -1 then 'Débito'
    when  1	then 'Crédito'
    else ''
    end
  end

  def self.ransackable_attributes(_auth_object = nil)
    %w[date_ocurrence city_id cost_id historic]
  end

  def self.saldo(city, date = nil)
    if date.nil?
      CurrentAccount.where(city_id: city).sum('price*type_launche')
    else
      CurrentAccount.where(city_id: city,
                           date_ocurrence: date).sum('price*type_launche')
    end
  end

  def self.saldo_anterior(city)
    CurrentAccount.where('current_accounts.city_id = ? and DATE(current_accounts.date_ocurrence) < ? ', city,
                         Time.zone.today.to_s.to_s).sum('price*type_launche')
  end

  def self.total_credito(city)
    CurrentAccount.total_creditos.where('current_accounts.city_id = ? and DATE(current_accounts.date_ocurrence) = ? ',
                                        city, Time.zone.today.to_s.to_s).sum('price')
  end

  def self.total_debito(city)
    CurrentAccount.where('current_accounts.city_id = ? and DATE(current_accounts.date_ocurrence) = ? ', city,
                         Time.zone.today.to_s.to_s).sum('price')
  end
end
