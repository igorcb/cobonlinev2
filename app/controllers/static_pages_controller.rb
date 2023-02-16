class StaticPagesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin

  def index; end

  def dashboard
    fields = 'cities.id as id,
    cities.name as cidade,
    sum(item_advances.price) as valor,
    sum(item_advances.value_payment) as valor_pago'

    filters = 'DATE(due_date) = ? '

    @item_advances = ItemAdvance.joins(:client, :city)
                                .select(fields).where(
                                  filters,
                                  Date.current.to_s
                                )
                                .group('cities.name, cities.id').order('cities.name')
  end

  def advance_dashboard; end

  def advance_search
    @data_ini = params[:data_ini]
    @data_fim = params[:data_fim]
    @advances = Advance.where('DATE(date_advance) >= ? AND DATE(date_advance) <= ?', @data_ini, @data_fim)
  end
end
