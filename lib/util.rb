module Util
  def proximo_dia_util(data)
    data += 2.days if data.saturday?
    data += 1.day if data.sunday?
    return proximo_dia_util(data + 1.day) if feriado(data)

    data
  end

  def ultimo_dia_util(data)
    data -= 1.day if data.saturday?
    data -= 2.days if data.sunday?
    return ultimo_dia_util(data - 1.day) if feriado(data)

    data
  end

  def feriado(data)
    holiday = Holiday.where(date_holiday: data)
    holiday.present?
  end
end
