require 'prawn/table'

class ContractTransactionPdf < Prawn::Document
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
    text "TERMO DE TRANSAÇÃO No #{@contract.id} / #{@contract.taxpayer.origin_code}", size: 10, style: :bold, align: :center
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "<b>Confederação da Agricultura e Pecuária do Brasil - CNA</b>, entidade sindical de grau superior , sem fins lucrativos, com sede no SEGAN 601 – Módulo K – Asa Norte - Brasília - DF, inscrita no CGC/MF sob o n.O 33.582.750/0001-78, sujeito ativo da obrigação, doravante denominada CREDORA, por seus procuradores signatários e", size: 9.5, :inline_format => true
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "#{@contract.taxpayer.name} - CPF #{@contract.taxpayer.cpf} - #{@contract.taxpayer.address} - #{@contract.taxpayer.city.name}/#{@contract.taxpayer.state} CEP #{@contract.taxpayer.zipcode}", size: 9.5, style: :bold
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "sujeito passivo da obrigação, assim enquadrado por força da Lei 9.701/98, doravante denominado DEVEDOR, RESOLVEM, de comum acordo, firmar a presente TRANSAÇÃO, a qual reger-se-á pelos artigos 841 do Código Civil e 156, III do Código Tributário Nacional e pelos seguintes termos: I – O devedor reconhece e confessa a existência dos débitos devidos a título de Contribuição Sindical, no total de", size: 9.5
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "<b> #{@contract.client_amount.real_contabil} (#{@contract.client_amount.to_f.round(2).por_extenso_em_reais}) </b> ACRESCIDO DE R$ <b> #{@contract.unit_amount.real_contabil} (#{@contract.unit_amount.to_f.round(2).por_extenso_em_reais}) </b> referente a honorários advocatícios", size: 9.5, :inline_format => true
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "referente ao(s) exercício(s) de ", size: 9.5
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "<b>#{contract_years}<b>", size: 9.5, style: :bold, :inline_format => true
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "por força dos artigos 149 da Constituição Federal e 578 e seguinte da CLT, renunciando expressamente a qualquer contestação relativa ao valor e precedência da dívida.", size: 9.5
    text "II – Como forma de compor o débito, as partes, mediante concessões mútuas, prevenindo litígio, estabelecem que o devedor pagará o débito, acrescido de honorários advocatícios no percentual de 10% (dez por cento), conforme permissivo legal constante dos arts. 389 e 395 do Código Civil.", size: 9.5
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "<b>EM #{@contract.client_ticket_quantity} PARCELA(s) DE #{client_ticket_amount.real_contabil} (#{client_ticket_amount.to_f.round(2).por_extenso_em_reais}) com vencimento(s) em#{ticket_due}. ACRESCIDO DE #{@contract.unit_amount.real_contabil} (#{@contract.unit_amount.to_f.round(2).por_extenso_em_reais}) REFERENTE A HONORÁRIOS ADVOCATÍCIOS COM VENCIMENTO EM #{@tickets.first.due.to_date.strftime('%d/%m/%Y')}</b>", size: 9.5, :inline_format => true
    move_down 5
    stroke_horizontal_rule
    move_down 5
    text "III - A quitação do débito confessado dar-se-á mediante o pagamento do valor previsto na cláusula anterior. Parágrafo Único - Em caso de inadimplemento de quaisquer das parcelas, a credora exigirá antecipadamente a integralidade do débito confessado na Cláusula I, computadas eventuais armortizações.", size: 9.5
    text "IV – O devedor responsabiliza-se pelos custos e despesas relativos à emissão dos boletos bancários, caso emitidos.", size: 9.5
    text "V – O devedor, nestes termos, declara compromisso firme, irretratável e irrevogável de liquidação do débito ora confessado, conforme acordado.", size: 9.5
    text "VI – O descumprimento de qualquer uma das cláusulas supra, implicará multa de 30% (trinta por cento) sobre o débito confessado na Cláusula I.", size: 9.5
    text "VII – As partes elegem o Foro da Comarca de Porto Alegre para dirimir quaisquer dúvidas oriundas do presente.", size: 9.5
    text "VIII – Na hipótese deste instrumento ser firmado após o ingresso da respectiva ação judicial perante a Justiça do Trabalho fica a CNA encarregada de comunicar ao juízo a efetivação da Transação, cabendo ao devedor suportar eventuais custas judiciais que forem arbitradas. E, por estarem assim justos e contratados, firmam por si e seus sucessores o presente termo, em 2 (duas) vias de igual teor e forma, para que surta os efeitos legais.", size: 9.5
    move_down 5
    stroke_horizontal_rule
    move_down 10
    text  "<b>Porto Alegre #{@contract.created_at.strftime('%d')} de #{Date::MONTHNAMES[@contract.created_at.strftime('%m').to_f]} de #{@contract.created_at.strftime('%Y')}.</b>", size: 10, :inline_format => true
    move_down 30
    stroke do 
      horizontal_line 000, 330
      horizontal_line 340, 555
    end
    move_down 5
    text "CONFEDERAÇÃO NACIONAL DA AGRICULTURA                                          #{@contract.taxpayer.name}", size: 10, style: :bold
    move_down 10
    text "TESTEMUNHAS:", size: 8
    move_down 15
    text "_______________________________________________                _______________________________________________", size: 8
    move_down 5
    text "NOME/CPF:                                                                                            NOME/CPF:", size: 8
    move_down 10
    stroke_horizontal_rule
    move_down 5
    text "<b>O PRESENTE INSTRUMENTO DEVERÁ SER DEVOLVIDO ASSINADO EM ATÉ 3 (TRÊS) DIAS DE SEU RECEBIMENTO, SOB PENA DE SEREM CONSIDERADOS INEFICAZES SEUS TERMOS.</b>", size: 8, :inline_format => true
    move_down 10
    text "Fone (51) 3254.6600 | www.gianellimartins.com.br | #{@unit.address} | #{@unit.city} | #{@unit.state} | CEP #{@unit.zipcode}", size: 8, style: :bold, align: :center

  end

  def contract_amount
    @contract.unit_amount + @contract.client_amount   
  end

  def ticket_due
    @tickets.collect{ |i| i.due.to_date.to_s_br if i.client?}.join(", ")
  end

  def contract_years
    @cnas.collect{ |i| i.year.to_s}.join(", ")
  end
  
  def client_ticket_amount
    @tickets.second.amount
  end
  
end
