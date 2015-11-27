require 'prawn/table'

class ContractPdf < Prawn::Document
  def initialize(unit, contract, tickets, cnas, view)
    super(left_margin:18, right_margin:18, top_margin: 20, page_size: "A4")
    @unit     = unit
    @contract = contract
    @tickets  = tickets  
    @cnas     = cnas
    @view     = view
    contract_body
  end

  def contract_body
    image "#{::Rails.root}/public/gianelli.png", :position => :center, :scale => 0.7
    move_down 20
    stroke_horizontal_rule
    move_down 5
    text "TERMO DE RENEGOCIAÇÃO DE ACORDO NÃO CUMPRIDO SOB O No #{@contract.id}", size: 10, style: :bold, align: :center
    move_down 20
    stroke_horizontal_rule
    move_down 5
    text "<b>CREDOR:</b> Confederação da Agricultura e Pecuária do Brasil - CNA, representada pela #{@contract.taxpayer.client.name}", size: 9.5, :inline_format => true
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "DEVEDOR: (#{@contract.taxpayer.origin_code.to_s}) #{@contract.taxpayer.name} - CPF #{@contract.taxpayer.cpf}", size: 9.5, style: :bold
    move_down 10
    text "EXERCÍCIOS: #{contract_years}", size: 9.5, style: :bold
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "RESOLVEM, de comum acordo, firmar a presente <b>NOVAÇÃO DO TERMO DE TRANSAÇÃO não cumprido</b> (a qual reger-se-á pelos artigos 360, I e art. 841 do C.C. e 585, II do CPC e ainda pelos seguintes termos:", size: 10, :inline_format => true
    move_down 2
    text "I – O débito esta sendo devidamente acrescido dos encargos previstos naquela negociação, que atualizado totaliza:", size: 10
    move_down 5
    stroke_horizontal_rule
    move_down 10
    text contract_amount.real_contabil, style: :bold
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "II – Como forma de resolver o litígio e compor o débito, as partes, estabelecem que o devedor pagará da seguinte forma:", size: 9.5
    move_down 2
    stroke_horizontal_rule
    move_down 10
    text "Em #{@contract.client_ticket_quantity} parcela(s), sendo:", size: 9.5, style: :bold
    move_down 10
    text "<b><u><i>PRIMEIRA</b></u></i> - <b>#{@contract.unit_amount.real_contabil}</b> - referente à taxa administrativa, com vencimento em #{@tickets.first.due.to_date.strftime('%d/%m/%Y')} (a ser paga através de boleto bancário).", size: 9.5, :inline_format => true
    move_down 10
    text "<b><u><i>O RESTANTE DE</b></u></i> <b>#{@contract.client_amount.real_contabil}</b>, a ser pago em #{@contract.client_ticket_quantity} parcela(s) com vencimento(s) em #{ticket_due}.", size: 9.5, :inline_format => true
    move_down 10
    stroke_horizontal_rule
    move_down 5
    text "III - A quitação do débito confessado dar-se-á mediante a comprovação do pagamento de todas as parcelas. Parágrafo Único - Em caso de inadimplemento de quaisquer das parcelas, a credora exigirá antecipadamente a integralidade do débito confessado na Cláusula I, computadas eventuais amortizações e os acréscimos previstos neste instrumento.", size: 9.5
    text "IV - O devedor responsabiliza-se pelos custos e despesas relativos à emissão dos boletos bancários, caso emitidos.", size: 9.5
    text "V - O devedor, nestes termos, declara compromisso firme, irretratável e irrevogável de liquidação do débito ora confessado, conforme acordado acima.", size: 9.5
    text "VI - O descumprimento de qualquer uma das cláusulas supra, implicará em multa de 30% (trinta por cento) sobre o débito confessado na Cláusula I.", size: 9.5
    text "VII - As partes elegem o Foro da Comarca de Porto Alegre/RS para dirimir quaisquer dúvidas oriundas do presente.", size: 9.5
    text "VIII - No caso de existência de processo em andamento, fica a CNA encarregada de comunicar ao juízo a efetivação do Acordo, requerendo a sua homologação e suspensão da execução até seu integral cumprimento, cabendo ao devedor suportar eventuais custas judiciais que forem arbitradas. Parágrafo único - É de responsabilidade do devedor encaminhar este documento devidamente assinado, pelo próprio e por duas testemunhas, em até 3 (três) dias do seu recebimento, com cópia do seu RG e CPF, sob pena de ser considerado ineficaz.", size: 9.5
    text "E, por estarem assim justos e contratados, firmam por si o presente termo, em 2 (duas) vias de igual teor e forma, para que surta os efeitos legais.", size: 9.5
    move_down 5
    stroke_horizontal_rule
    move_down 20
    text  "Porto Alegre #{@contract.created_at.strftime('%d')} de #{Date::MONTHNAMES[@contract.created_at.strftime('%m').to_f]} de #{@contract.created_at.strftime('%Y')}.", size: 10
    move_down 50
    stroke do 
      horizontal_line 000, 330
      horizontal_line 340, 555
    end
    move_down 5
    text "CONFEDERAÇÃO DA AGRICULTURA E PECUÁRIA DO BRASIL – CNA   #{@contract.taxpayer.name}", size: 10, style: :bold
    move_down 20
    text "TESTEMUNHAS:", size: 8
    move_down 50
    text "_______________________________________________                _______________________________________________", size: 8
    move_down 10
    text "NOME/CPF:                                                                                            NOME/CPF:", size: 8
    move_down 20
    text "Fone (51) 3254.6600 | www.gianellimartins.com.br | #{@unit.address} | #{@unit.city} | #{@unit.state} | CEP #{@unit.zipcode}", size: 9, style: :bold, align: :center

  end

  def contract_amount
    @contract.unit_amount + @contract.client_amount   
  end

  def ticket_due
    @tickets.collect{ |i| i.due.to_date.to_s_br}.join(", ")
  end

  def contract_years
    @cnas.collect{ |i| i.year.to_s}.join(", ")
  end
end
