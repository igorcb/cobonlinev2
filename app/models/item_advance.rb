require 'util'

class ItemAdvance < ApplicationRecord
  include Util
  belongs_to :advance
  has_one :client, through: :advance
  has_one :city, through: :client

  scope :order_asc, -> { order(due_date: :asc) }
  scope :order_desc, -> { order(due_date: :desc) }

  def self.items_operator(user)
    filters = 'DATE(item_advances.due_date) = ? and advances.status = ? and advances.client_id in (?) '
    city_id = user.city_id || nil
    @clients = Client.where(city_id: city_id)
    ItemAdvance.joins(:advance)
               .includes(:client)
               .where(
                 filters,
                 Time.zone.today.to_s,
                 Advance::TypeStatus::ABERTO,
                 @clients.ids
               )
  end

  def self.items_admin
    filters = 'DATE(item_advances.due_date) = ? and advances.status = ?'
    ItemAdvance.joins(:advance)
               .includes(:client)
               .where(
                 filters,
                 Time.zone.today.to_s,
                 Advance::TypeStatus::ABERTO
               )
  end

  def self.total_diaria(city_id)
    fields = 'cities.id as id,
    cities.name as cidade,
    sum(item_advances.price) as valor,
    sum(item_advances.value_payment) as valor_pago'

    filters = 'cities.id = ? and DATE(due_date) = ? and advances.status = ? '

    @item_advances =
      ItemAdvance.joins(:advance, :client, :city)
                 .select(fields)
                 .where(filters,
                        city_id,
                        Date.current.to_s,
                        Advance::TypeStatus::ABERTO).sum(:price)
  end

  def self.total_cobrado(city_id)
    fields = 'cities.id as id,
    cities.name as cidade,
    sum(item_advances.price) as valor,
    sum(item_advances.value_payment) as valor_pago'

    filters = 'cities.id = ?
    and DATE(due_date) = ?
    and advances.status = ?'

    @item_advances =
      ItemAdvance.joins(:advance, :client, :city)
                 .select(fields)
                 .where(
                   filters,
                   city_id,
                   Date.current,
                   Advance::TypeStatus::ABERTO
                 )
                 .sum(:value_payment)
  end
end
