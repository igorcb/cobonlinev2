class ClientsController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin
  before_action :set_client, only: %i[show edit update destroy]

  # GET /clients
  # GET /clients.json
  def index
    @clients = Client.all
  end

  # GET /clients/1
  # GET /clients/1.json
  def show; end

  # GET /clients/new
  def new
    @client = Client.new
  end

  # GET /clients/1/edit
  def edit; end

  # POST /clients
  # POST /clients.json
  def create
    @client = Client.new(client_params)

    respond_to do |format|
      if @client.save
        format.html do
          redirect_to client_url(@client), notice: notice_message(:create_successfully)
        end
        format.json { render :show, status: :created, location: @client }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clients/1
  # PATCH/PUT /clients/1.json
  def update
    respond_to do |format|
      if @client.update!(client_params)
        format.html do
          redirect_to @client, notice: notice_message(:update_successfully)
        end
        format.json { render :show, status: :ok, location: @client }
      else
        format.html { render :edit }
        format.json { render json: @client.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clients/1
  # DELETE /clients/1.json
  def destroy
    @client.destroy
    respond_to do |format|
      format.html do
        redirect_to clients_url, notice: notice_message(:destroy_successfully)
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_client
    @client = Client.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def client_params
    params.require(:client).permit(:type_trade_id, :city_id, :name, :fone, :cpf, :rg, :birthday,
                                   :type_payment, :credit_limit, :indication, :status,
                                   :home_address, :home_number, :home_complement, :home_district, :home_city,
                                   :home_state, :home_zip, :home_link,
                                   :billing_address, :billing_number, :billing_complement, :billing_district,
                                   :billing_city, :billing_state, :billing_zip, :billing_link,
                                   :references_one_name, :references_one_origin, :references_one_phone,
                                   :references_two_name, :references_two_origin, :references_two_phone,
                                   :references_three_name, :references_three_origin, :references_three_phone)
  end
end
