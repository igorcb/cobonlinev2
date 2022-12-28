class CurrentAccountsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_current_account, only: [:show, :edit, :update, :destroy]

  def launch_current
    price = params[:price]
    CurrentAccount.create!(city_id: 1, 
                           cost_id: CurrentAccount::TypeCost::RECEBIMENTO_COBRANCA, 
                    date_ocurrence: Date.today, 
                      type_launche: CurrentAccount::TypeLaunche::CREDITO, 
                             price: price, 
                          historic: "RECEBIMENO DE COBRANÇA AUTOMATICO")
    redirect_to index_user_operator_current_accounts_path
  end

  def search
    if current_user.admin?
      @q = CurrentAccount.ransack(params[:q])
    else
      @query = CurrentAccount.where(city_id: current_user.city_id)
      @q = @query.ransack(params[:q])
    end
    @current_accounts = @q.result.paginate(:page => params[:page]).order(date_ocurrence: :desc)
  end  

  # GET /current_accounts
  # GET /current_accounts.json
  def index
    if current_user.admin?
      @q = CurrentAccount.ransack(params[:q])
    else
      @query = CurrentAccount.where(city_id: current_user.city_id)
      @q = @query.ransack(params[:q])
    end
    @current_accounts = @q.result.paginate(:page => params[:page]).order(date_ocurrence: :desc)
  end

  def index_user_operator
    @current_accounts = CurrentAccount.where(city_id: current_user.city_id).order(date_ocurrence: :desc)
  end

  # GET /current_accounts/1
  # GET /current_accounts/1.json
  def show
  end

  # GET /current_accounts/new
  def new
    @current_account = CurrentAccount.new
  end

  # GET /current_accounts/1/edit
  def edit
  end

  # POST /current_accounts
  # POST /current_accounts.json
  def create
    @current_account = CurrentAccount.new(current_account_params)

    respond_to do |format|
      if @current_account.save
        format.html { redirect_to @current_account, notice: 'Current account was successfully created.' }
        format.json { render :show, status: :created, location: @current_account }
      else
        format.html { render :new }
        format.json { render json: @current_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /current_accounts/1
  # PATCH/PUT /current_accounts/1.json
  def update
    respond_to do |format|
      if @current_account.update(current_account_params)
        format.html { redirect_to @current_account, notice: 'Current account was successfully updated.' }
        format.json { render :show, status: :ok, location: @current_account }
      else
        format.html { render :edit }
        format.json { render json: @current_account.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /current_accounts/1
  # DELETE /current_accounts/1.json
  def destroy
    @current_account.destroy
    respond_to do |format|
      format.html { redirect_to current_accounts_url, notice: 'Current account was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_current_account
      @current_account = CurrentAccount.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def current_account_params
      params.require(:current_account).permit(:city_id, :cost_id, :date_ocurrence, :type_launche, :price, :historic)
    end
end
