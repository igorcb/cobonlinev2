class UpdateDelayAndResidueToItemAdvances < ActiveRecord::Migration[7.0]
  def change
    ItemAdvance.where(date_payment: nil).update(delay: nil, residue: nil)
  end
end
