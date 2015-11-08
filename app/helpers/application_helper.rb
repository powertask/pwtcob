module ApplicationHelper

  def calc_months(year)
  	date_base = Date.new(year, 5, 22)
  	date_today = Date.today()
  	(date_today.year * 12 + date_today.month) - (date_base.year * 12 + date_base.month)
  end

  def calc_multa(cna)
  	months = calc_months(cna.year)
    @value = cna.amount

    (1..months).map{|x|@value = @value + (x == 1 ? @value * 0.1 : @value * 0.02)}.last
    @value.round(2)
  end

  def calc_juros(cna)
    months = calc_months(cna.year)
    @value = cna.amount

    (1..months).map{|x|@value = @value + ( @value * 0.01 )}.last

    @value.round(2)
  end

  def calc_cna(cna)
    amount = cna.amount
    multa = calc_multa(cna)
    juros = calc_juros(cna)
    total = amount + multa + juros

    session[:value_cna] = session[:value_cna] + amount
    session[:total_multa] = session[:total_multa] + multa
    session[:total_juros] = session[:total_juros] + juros
    session[:total_cna] = session[:total_cna] + total
    total
  end

end
