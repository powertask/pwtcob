require 'prawn/table'

class ContractPdf < Prawn::Document
  def initialize(params, view)
    super(top_margin: 70, page_size: "A4")
    @params   = params
    @view     = view
    contract_header
 #   ticket_detail
 #   ticket_trailer
  end

  def contract_header
    move_down 5
    text "TERMO DE RENEGOCIACAO DE ACORDO NAO CUMPRIDO SOB O No", size: 10, style: :bold, align: :center
    move_down 2
    stroke_horizontal_rule
    text "DEVEDOR: "
    move_down 2
    text "EXERCICIOS: "
    stroke_horizontal_rule
    move_down 2
    text "RESOLVEM, de comum acordo, firmar a presente NOVACAO DO TERMO DE TRANSACAO nao cumprido (a qual reger-se-"
    text "a pelos artigos 360, I e art. 841 do C.C. e 585, II do CPC e ainda pelos seguintes termos:"
    text "I – O debito esta sendo devidamente acrescido dos encargos previstos naquela negociacao, que atualizado totaliza:"
  end

  def ticket_detail
    move_down 20
    font("Times-Roman", :size => 8)
    table ticket_rows do
      row(0).font_style = :bold
      columns(1..3).align = :left
      columns(3..4).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
      self.header = true
    end
  end

  def ticket_trailer
    move_down 20
    text "Valor Total: #{@tickets.sum("ticket_procedures.price").to_f.round(2).real_contabil unless @tickets.empty?}", size: 15, style: :bold, align: :right
    text "#{@tickets.size} exame(s)", size: 15, style: :bold, align: :right
    move_down 10
    stroke_horizontal_rule
    move_down 10
    text "Faturamento do Medico", size: 15, style: :bold, align: :left

    data = [
            ["Valor Faturado:", "#{@params[5].real_contabil unless @tickets.empty?}"],
            ["Valor Bruto (#{@params[6]}%)", "#{@params[7].real_contabil unless @tickets.empty?}"],
            ["IRRF (#{@params[8]}%)", "#{@params[9].real_contabil unless @tickets.empty?}"],
            ["COFINS (#{@params[10]}%)", "#{@params[11].real_contabil unless @tickets.empty?}"],
            ["Total Liquido", "#{@params[12].real_contabil unless @tickets.empty?}"],
          ]

    table data do
      row(4).font_style = :bold
      columns(1).align = :right
      self.row_colors = ["DDDDDD", "FFFFFF"]
    end

    string = "Pagina <page> de <total>"
    options = { :at => [bounds.right - 150, 0],
                :width => 150,
                :align => :right,
                :start_count_at => 1 }
    number_pages string, options
  end

  def ticket_rows
    [["Nome Paciente", "Procedimento", "Codigo", "Valor"]] +
    @tickets.map do |item|
      [item.pacient_name, item.procedure_name, item.procedure_code, price(item.procedure_price)]
    end
  end

  def price(num)
     @view.number_to_currency(num)
  end
end
