class AdvancePrint < Prawn::Document
  include ApplicationHelper
  PDF_OPTIONS = {
    :page_size   => "A4",
    :page_layout => :landscape,
    # :background  => "public/images/cert_bg.png",
    :margin      => [40,40]
  }

  def initialize(advance)
    super()
    @advance = advance
    header
    #certificate
  end
  
  private

  def header
    # fill_color "40464e"
    move_down 05
    text "<b>Nome:</b> #{@advance.client.name}", :inline_format => true

    move_down 05
    text "<b>Data:</b> #{@advance.date_advance}     <b>Valor:</b> #{@advance.price}", :inline_format => true

    move_down 15
    table_header = ["Parc", "Data", "Pago", "Atraso", "Resta", "Ass"]
    table_data = []

    @advance.item_advances.order(id: :asc).each do |i|
      item = []
      item.push(i.parts)
      item.push(date_br(i.due_date))
      item.push(i.value_payment.to_f)
      item.push(i.delay.to_f)
      item.push(i.residue)
      item.push("               ")
      table_data.push(item)
    end

    data = [table_header]
    data += table_data
    table(data, :header => true)
  end

  def certificate 
    Prawn::Document.new() do |pdf|
      pdf.fill_color "40464e"
      pdf.text "Ruby Metaprogramming", :size => 40, :style => :bold, :align => :center

      pdf.move_down 30
      pdf.text "Certificado", :size => 24, :align => :center, :style => :bold

      pdf.move_down 30
      pdf.text "Certificamos que <b>Nando Vieira</b> participou...", :inline_format => true

      pdf.move_down 15
      pdf.text "São Paulo, #{Time.now.to_formatted_s(:short)}"

      pdf.move_down 30
      # pdf.font Rails.root.join("fonts/custom.ttf")
      pdf.text "howto", :size => 24

      pdf.move_up 5
      pdf.font "Helvetica"
      pdf.text "http://howtocode.com.br", :size => 10
    end
  end
end