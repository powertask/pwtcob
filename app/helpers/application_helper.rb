module ApplicationHelper

  def calc_meses_atraso(_dt_ini, _dt_end)
    (_dt_end.year * 12 + _dt_end.month) - (_dt_ini.year * 12 + _dt_ini.month)
  end


  def calc_valor_corrigido_INPC(_dt_ini, _dt_end, _value) 
    _dt_ini_month = _dt_ini.month()
    _dt_ini_year = _dt_ini.year()

    _dt_end_month = _dt_end.month()    
    _dt_end_year = _dt_end.year()



    inpc = Inpc.where('year between ? AND ? AND unit_id = ?', _dt_ini_year, _dt_end_year, 1)

  end

  def calc_multa(_dt_ini, _dt_end, _value)
  	months = calc_meses_atraso(_dt_ini, _dt_end)
    _perc = (10 + ((months - 1) * 2)).round(2)
    _new_value = (_value * (_perc / 100)).round(2)
  end

  def calc_juros(_dt_ini, _dt_end, _value)
    months = calc_meses_atraso(_dt_ini, _dt_end)
    _perc = (months * 0.01).round(2)
    _new_value = (_value * _perc).round(2)
  end

  def calc_cna(cna)
    _dt_ini = Date.new(cna.year,5,22)
    _dt_end = Date.today
    _value = cna.amount
    
    charge = 0

    _correcao = calc_valor_corrigido_INPC(_dt_ini, _dt_end, _value)
    _multa = calc_multa(_dt_ini, _dt_end, _correcao)
    _juros = calc_juros(_dt_ini, _dt_end, _correcao)
    total_cna = _correcao + _multa + _juros

    charge = charge + total_cna if cna.fl_charge

    session[:value_cna] = (session[:value_cna].nil? ? 0 : session[:value_cna]) + (amount.nil? ? 0 : amount)
    session[:total_multa] = (session[:total_multa].nil? ? 0 : session[:total_multa]) + (multa.nil? ? 0 : multa)
    session[:total_juros] = (session[:total_juros].nil? ? 0 : session[:total_juros]) + (juros.nil? ? 0 : juros)
    session[:total_cobrado] = (session[:total_cobrado].nil? ? 0 : session[:total_cobrado]) + (charge.nil? ? 0 : charge)
    session[:total_cna] = (session[:total_cna].nil? ? 0 : session[:total_cna]) + (total_cna.nil? ? 0 : total_cna)

    total_cna
  end

end
