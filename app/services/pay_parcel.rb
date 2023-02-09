require 'util'

class PayParcel
  include Util
  def initialize(parcel, date_payment, value_payment)
    @parcel = parcel
    @date_payment = date_payment
    @value_payment = value_payment
  end

  def call
    delay = calculate_delay
    residue = calculate_residue
    
    @parcel.update(
      date_payment: @date_payment,
      value_payment: @value_payment,
      delay: delay,
      residue: residue,
    )

    # if ((@parcel.advance.last.due_date.to_s == data_pagamemto.to_s) && (@parcel.advance.balance > 0.00))

    # end

  end

  private
    def first_parcel?(parts)
      part = parts.split("/")
      part[0] == "001"
    end

    def last_parcel?(parcel)
      parcel.advance.last
    end

    def calculate_residue
      if first_parcel?(@parcel.parts)
        @parcel.advance.price - @value_payment
      else
        day_previus = ultimo_dia_util(@parcel.due_date - 1)
        parcel_previus = @parcel.advance.item_advances.where(due_date: day_previus).first
        parcel_previus.residue - @value_payment
      end
    end

    def calculate_delay
      if first_parcel?(@parcel.parts)
        @value_payment == 0.00 ? @parcel.price : @parcel.price - @value_payment
      else
        day_previus = ultimo_dia_util(@parcel.due_date - 1)
        parcel_previus = @parcel.advance.item_advances.where(due_date: day_previus).first
        @parcel.price - @value_payment + parcel_previus.delay
      end
    end
end