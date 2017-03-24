require 'prawn'
require 'prawn/table'

class ReportPaymentPdf < Prawn::Document
  def initialize(rels, params, view)
    super(top_margin: 70, page_size: "A4", page_layout: :portrait)
    @rels  = rels
    @params = params
    @view  = view
    header
    detail
    trailer
  end

  def header
    text "Relatorio de Pagamentos Efetuados para #{@params[2] == '0' ? 'FAESC' : 'GMA'} no Periodo de #{@params[0].to_date.strftime('%d/%m/%Y')} A #{@params[1].to_date.strftime('%d/%m/%Y')}", size: 9, style: :bold
    stroke_horizontal_rule
  end

  def detail
    move_down 5
    font("Courier", :size => 6)

    data  = [["Contribuinte", "Cidade", "CPF", "Exercício", "Parcela", "Valor", "Vencimento", "Pagamento", "Colaborador(a)"]]  + 
            @rels.collect{ |p| [p.tname, p.cname, p.cpf, p.description, p.ticket_type == 'client' ? ((p.ticket_number - 1).to_s + '/' + p.client_ticket_quantity.to_s) : '1/1', p.paid_amount.contabil, p.due.to_date.strftime('%d/%m/%Y'), p.paid_at.strftime('%d/%m/%Y'), p.name]}

    table(data) do
      cells.padding     = 1
      cells.borders     = []
      columns(1).width  = 80
      columns(2).width  = 50
      columns(4).width  = 30
      columns(5..7).width  = 40
    end
  end

  def trailer
    move_down 20
    text "Totais Pagos #{@rels.collect{|p| p.paid_amount}.inject(:+).real_contabil}", size: 9, style: :bold, align: :left

    string = "Pagina <page> de <total>"
    options = { :at => [bounds.right - 150, 0],
                :width => 150,
                :align => :right,
                :start_count_at => 1 }
    number_pages string, options
  end

end
