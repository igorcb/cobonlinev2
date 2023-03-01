class AdvancesController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin
  before_action :set_advance, only: %i[show edit update destroy recalculation print]

  def client_for_city
    # puts ">>>>>>>>>>>>>>>> cost_center_id: #{params[:cost_center_id].to_i}"
    city_id = params[:city_id].to_i
    subs = Client.order_asc.where(city_id: city_id)
    sub = []
    subs.each do |s|
      sub << { id: s.id, n: s.name }
    end
    render text: sub.to_json
  end

  # GET /advances
  # GET /advances.json
  def index
    @advances = Advance.order_desc
    @cities = City.all
  end

  # GET /advances/1
  # GET /advances/1.json
  def show; end

  # GET /advances/new
  def new
    @advance = Advance.new
  end

  # GET /advances/1/edit
  def edit
    return unless @advance.paid?

    redirect_to advances_path, flash: { alert: 'Emprestimo com paracelas pagas, não é possível editar.' }
    nil
  end

  # POST /advances
  # POST /advances.json
  def create
    @advance = Advance.new(advance_params)

    respond_to do |format|
      if @advance.save
        format.html { redirect_to @advance, notice: notice_message(:create_successfully) }
        format.json { render :show, status: :created, location: @advance }
      else
        format.html { render :new }
        format.json { render json: @advance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /advances/1
  # PATCH/PUT /advances/1.json
  def update
    old_value = @advance.price - @advance.lucre

    respond_to do |format|
      if @advance.update_and_cache(advance_params, old_value)
        format.html { redirect_to @advance, notice: notice_message(:update_successfully) }
        format.json { render :show, status: :ok, location: @advance }
      else
        redirect_to advances_path, flash: { alert: 'Ocorreu um erro ao editar o emprestimo, tente novamente.' }
        return
      end
    end
  end

  # DELETE /advances/1
  # DELETE /advances/1.json
  def destroy
    if @advance.paid?
      redirect_to advances_path, flash: { alert: 'Emprestimo com paracelas pagas, não é possível excluir.' }
      return
    end

    @advance.destroy
    respond_to do |format|
      format.html { redirect_to advances_url, notice: notice_message(:destroy_successfully) }
      format.json { head :no_content }
    end
  end

  def recalculation
    Rails.logger.debug { ">>>>>>>>>>>>>>> Recalculation Advance ID: #{@advance.id}" }
    @advance.recalculation
    redirect_to advances_path
  end

  def print
    pdf = AdvancePrint.new(@advance)

    send_data(pdf.render, filename: "Advance_#{@advance.id}.pdf", type: 'application/pdf', disposition: 'inline')
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_advance
    @advance = Advance.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def advance_params
    params.require(:advance).permit(:date_advance, :client_id, :price, :number_parts, :percent, :observation)
  end
end
