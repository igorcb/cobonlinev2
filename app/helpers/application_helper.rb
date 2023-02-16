module ApplicationHelper
  def full_title(page_title)
    base_title = 'Sistema de Cobrança OnLine'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def nav_link(text, path)
    options = current_page?(path) ? { class: 'active' } : {}
    content_tag(:li, options) do
      link_to t(text), path
    end
  end

  def date_br(date)
    date.nil? ? '' : I18n.l(date, format: '%d/%m/%Y')
  end

  def select_credito_debito
    [['Débito', -1], ['Crédito', 1]]
  end
end
