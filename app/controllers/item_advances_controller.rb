class ItemAdvancesController < ApplicationController
  before_action :authenticate_user!

  def index
    @item_advances = if current_user.admin?
                       ItemAdvance.item_admin
                     else
                       ItemAdvance.items_operator(current_user)
                     end
  end

  def edit
    @item_advance = ItemAdvance.find(params[:id])
  end

  def update
    @item_advance = ItemAdvance.find(params[:id])

    if params[:value_payment].blank?
      if current_user.admin?
        redirect_to edit_item_advance_path(@item_advance), flash: { alert: 'Informe o valor da parcela' }
      else
        redirect_to item_advances_path, flash: { alert: 'Informe o valor da parcela' }
      end
      nil
    else
      date_payment = if current_user.admin?
                       params[:date_payment]
                     else
                       Date.current.to_s
                     end

      value_payment = params[:value_payment]
      # TODO: Adicionar a nota/observação no servico onde efetua a baixa
      note = params[:note]

      if ItemAdvances::PayParcel.new(@item_advance, date_payment.to_date, value_payment.to_f, note).call
        respond_to do |format|
          flash[:notice] = 'Parcela foi atualizada com sucesso.'
          if current_user.admin?
            format.html { redirect_to advance_path(@item_advance.advance) }
          else
            format.html { redirect_to item_advances_path }
          end
        end
      elsif current_user.admin?
        redirect_to edit_item_advance_path(@item_advance),
                    flash: { alert: 'Ocorreu um erro ao efetuar a baixa da parcela' }
      else
        redirect_to item_advances_path, flash: { alert: 'Ocorreu um erro ao efetuar a baixa da parcela' }
      end
    end
  end

  def destroy
    @item_advance.destroy
    respond_to do |format|
      format.html { redirect_to advance, notice: 'ItemAdvance destroyed was successfully.' }
      format.json { head :no_content }
    end
  end
end
