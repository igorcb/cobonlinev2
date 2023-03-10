require 'util'

module ItemAdvances
  class PayParcel
    include Util
    def initialize(parcel, date_payment, value_payment, note)
      @parcel = parcel
      @date_payment = date_payment
      @value_payment = value_payment
      @note = note
    end

    def call
      @last_parcel = @parcel.advance.item_advances.last
      delay = calculate_delay
      residue = calculate_residue

      ActiveRecord::Base.transaction do
        @parcel.update(
          date_payment: @date_payment,
          value_payment: @value_payment,
          delay: delay,
          residue: residue,
          note: @note
        )

        generate_new_parcel if generate_new_parcel?

        if @parcel.advance.balance <= 0.00
          Advance.where(id: @parcel.advance.id).update(status: Advance::TypeStatus::FECHADO)
        end

        true
      end
      # TODO: implementar quando ocorrer um erro na baixa da parcela
      # rescue ActiveRecord::RecordInvalid
      #   puts "Oops. We tried to do an invalid operation!"
      # end
    end

    private

    def first_parcel?(parts)
      part = parts.split('/')
      part[0] == '001'
    end

    def calculate_residue
      if first_parcel?(@parcel.parts)
        @parcel.advance.price - @value_payment
      else
        day_previus = ultimo_dia_util(@parcel.due_date - 1)
        parcel_previus = @parcel.advance.item_advances.where(due_date: day_previus).first
        residue = parcel_previus.residue || 0.00
        residue - @value_payment
      end
    end

    def calculate_delay
      if first_parcel?(@parcel.parts)
        @value_payment == BigDecimal('0.00') ? @parcel.price : @parcel.price - @value_payment
      else
        day_previus = ultimo_dia_util(@parcel.due_date - 1)
        parcel_previus = @parcel.advance.item_advances.where(due_date: day_previus).first
        delay = parcel_previus.delay || 0.00
        @parcel.price - @value_payment + delay
      end
    end

    def generate_new_parcel?
      ((@last_parcel.due_date.to_s == @date_payment.to_s) && (@parcel.advance.balance > 0.00))
    end

    def generate_new_parcel
      parts = new_parts(@last_parcel.parts)
      due_date = proximo_dia_util(@last_parcel.due_date + 1.day)
      price = @last_parcel.price
      @parcel.advance.item_advances.create(
        parts: parts,
        price: price,
        due_date: due_date,
        delay: 0,
        residue: 0
      )
    end

    def new_parts(value)
      number_parts = value[0..2].to_i
      temp_parts = (number_parts + 1).to_s.rjust(3, '0')
      "#{temp_parts}/#{number_parts}"
    end
  end
end
