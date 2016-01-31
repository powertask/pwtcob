module ApplicationHelper

  def calc_meses_atraso(cna, _dt_ini, _dt_end)
    
    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    
    if _dt_ini.month != _dt_end.month
      _dt_end = _dt_end - 1.month if _dt_end.day < 22
    end

    (_dt_end.year * 12 + _dt_end.month) - (_dt_ini.year * 12 + _dt_ini.month)
  end


  def calc_valor_corrigido_INPC(cna, _dt_ini, _dt_end) 
    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?

    _dt_ini = Date.new(_dt_ini.year, _dt_ini.month, 1)
    _dt_end = Date.new(_dt_end.year, _dt_end.month, 1) + 1.month - 1.day
    _value = cna.amount

    inpcs = Inpc.where("idx_date between ? AND ?", _dt_ini, _dt_end)
    idx_sum = 0

    inpcs.each do |inpc|
      _value = _value + (_value * (inpc.idx/100))
    end
    
    (_value ).to_f.round(2)
  end


  def calc_multa(cna, _dt_ini, _dt_end)
    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    _value = calc_valor_corrigido_INPC(cna, _dt_ini, _dt_end).to_f

  	_months = calc_meses_atraso(cna, _dt_ini, _dt_end)
    _perc = (10 + ((_months - 1) * 2)).round(2)
    _new_value = (_value * (_perc / 100)).round(2)
  end


  def calc_juros(cna, _dt_ini, _dt_end)
    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    _value = calc_valor_corrigido_INPC(cna, _dt_ini, _dt_end).to_f

    _months = calc_meses_atraso(cna, _dt_ini, _dt_end)
    _perc = (_months * 0.01).round(2)
    _new_value = (_value * _perc).round(2)
  end


  def calc_cna(cna, _dt_ini, _dt_end)
    _dt_ini = Date.new(cna.year,5,22) if _dt_ini.nil?
    _dt_end = Date.current if _dt_end.nil?
    
    charge = 0

    _correcao = calc_valor_corrigido_INPC(cna, _dt_ini, _dt_end)
    _multa = calc_multa(cna, _dt_ini, _dt_end)
    _juros = calc_juros(cna, _dt_ini, _dt_end)
    total_cna = _correcao + _multa + _juros

    charge = charge + total_cna if cna.fl_charge

    session[:value_cna] = (session[:value_cna].nil? ? 0 : session[:value_cna]) + (cna.amount.nil? ? 0 : cna.amount)
    session[:total_multa] = (session[:total_multa].nil? ? 0 : session[:total_multa]) + (_multa.nil? ? 0 : _multa)
    session[:total_juros] = (session[:total_juros].nil? ? 0 : session[:total_juros]) + (_juros.nil? ? 0 : _juros)
    session[:total_cobrado] = (session[:total_cobrado].nil? ? 0 : session[:total_cobrado]) + (charge.nil? ? 0 : charge)
    session[:total_cna] = (session[:total_cna].nil? ? 0 : session[:total_cna]) + (total_cna.nil? ? 0 : total_cna)

    session[:total_fee] = Unit.unit_fee(session[:unit_id], session[:total_cobrado])

    total_cna
  end

end
