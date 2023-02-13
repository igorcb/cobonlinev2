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
  end
  
  private

  def header
    # fill_color "40464e"
    rows = (@advance.item_advances.count - 20) * 20
    height = 580 + rows
    
    bounding_box([0, cursor - 5], width: 345, height: height) do
      indent(20) do
        move_down 10
        text "<b>Nome:</b> #{@advance.client.name}", :inline_format => true
    
        move_down 05
        bounds.left
        text "<b>Data:</b> #{@advance.date_advance}     <b>Valor:</b> R$ #{@advance.price}", :inline_format => true
        
        move_down 15
  
        table_header = ["Parc", "Data", "Pago", "Resta", "Atraso", "Ass"]
        table_data = []

        @advance.item_advances.order(id: :asc).each do |i|
          item = []
          item.push(i.parts)
          item.push(date_br(i.due_date))
          item.push(i.value_payment.to_f)
          item.push(i.residue&.to_f)
          item.push(i.delay&.to_f )
          item.push("               ")
          table_data.push(item)
        end

        data = [table_header]
        data += table_data
        table(data, :header => true)
      end
          
      transparent(0.5) { stroke_bounds }
    end
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