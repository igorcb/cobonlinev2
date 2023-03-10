class HolidaysController < ApplicationController
  before_action :authenticate_user!
  before_action :user_admin
  before_action :set_holiday, only: %i[show edit update destroy]

  # GET /holidays
  # GET /holidays.json
  def index
    @holidays = Holiday.all
  end

  # GET /holidays/1
  # GET /holidays/1.json
  def show; end

  # GET /holidays/new
  def new
    @holiday = Holiday.new
  end

  # GET /holidays/1/edit
  def edit; end

  # POST /holidays
  # POST /holidays.json
  def create
    @holiday = Holiday.new(holiday_params)

    respond_to do |format|
      if @holiday.save
        format.html { redirect_to @holiday, notice: notice_message(:create_successfully) }
        format.json { render :show, status: :created, location: @holiday }
      else
        format.html { render :new }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /holidays/1
  # PATCH/PUT /holidays/1.json
  def update
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to @holiday, notice: notice_message(:update_successfully) }
        format.json { render :show, status: :ok, location: @holiday }
      else
        format.html { render :edit }
        format.json { render json: @holiday.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /holidays/1
  # DELETE /holidays/1.json
  def destroy
    @holiday.destroy
    respond_to do |format|
      format.html { redirect_to holidays_url, notice: notice_message(:destroy_successfully) }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def holiday_params
    params.require(:holiday).permit(:name, :date_holiday)
  end
end
