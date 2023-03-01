class TypeTradesController < ApplicationController
  before_action :set_type_trade, only: %i[show edit update destroy]

  # GET /type_trades or /type_trades.json
  def index
    @type_trades = TypeTrade.all
  end

  # GET /type_trades/1 or /type_trades/1.json
  def show; end

  # GET /type_trades/new
  def new
    @type_trade = TypeTrade.new
  end

  # GET /type_trades/1/edit
  def edit; end

  # POST /type_trades or /type_trades.json
  def create
    @type_trade = TypeTrade.new(type_trade_params)

    respond_to do |format|
      if @type_trade.save
        format.html { redirect_to type_trade_url(@type_trade), notice: notice_message(:create_successfully) }
        format.json { render :show, status: :created, location: @type_trade }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @type_trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_trades/1 or /type_trades/1.json
  def update
    respond_to do |format|
      if @type_trade.update(type_trade_params)
        format.html { redirect_to type_trade_url(@type_trade), notice: notice_message(:update_successfully) }
        format.json { render :show, status: :ok, location: @type_trade }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @type_trade.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_trades/1 or /type_trades/1.json
  def destroy
    @type_trade.destroy

    respond_to do |format|
      format.html { redirect_to type_trades_url, notice: notice_message(:destroy_successfully) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_type_trade
    @type_trade = TypeTrade.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def type_trade_params
    params.require(:type_trade).permit(:name)
  end
end
