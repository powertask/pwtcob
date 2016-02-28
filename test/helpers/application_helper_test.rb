require 'test_helper'
 
class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  
  test "meses em atraso" do
    _dt_ini = Date.new(2015,5,22)
    _dt_end = Date.new(2015,6,21)
    _meses_atraso = calc_meses_atraso(cna, _dt_ini, _dt_end)
    assert_equal 0, _meses_atraso

    _dt_end = Date.new(2015,6,21)
    cna = Cna.first
    _meses_atraso = calc_meses_atraso(cna, nil, _dt_end)
    assert_equal 0, _meses_atraso

    _dt_ini = Date.current
    _dt_end = Date.current
    _meses_atraso = calc_meses_atraso(cna, _dt_ini, _dt_end)
    assert_equal 0, _meses_atraso

    _dt_ini = Date.new(2015,5,22)
    _dt_end = Date.new(2015,7,21)
    _meses_atraso = calc_meses_atraso(cna, _dt_ini, _dt_end)
    assert_equal 1, _meses_atraso

    _dt_ini = Date.new(2015,5,22)
    _dt_end = Date.new(2015,7,22)
    _meses_atraso = calc_meses_atraso(cna, _dt_ini, _dt_end)
    assert_equal 2, _meses_atraso

    _dt_ini = Date.new(2010,5,22)
    _dt_end = Date.new(2010,12,31)
    _meses_atraso = calc_meses_atraso(cna, _dt_ini, _dt_end)
    assert_equal 7, _meses_atraso

  end

  test 'calc_valor_corrigido_INPC' do
    skip
  	_dt_ini = Date.new(2010,5,22)
  	_dt_end = Date.new(2010,12,31)
  	cna = Cna.first  

  	_new_value = calc_valor_corrigido_INPC(cna, _dt_ini, _dt_end)

  	assert_equal 138.53, _new_value
  end

  test 'calc_multa' do
    cna = Cna.first
  	value = calc_multa(cna, Date.new(2010,5,22), Date.new(2015,11,22))
  	assert_equal 267.23, value

    cna = Cna.second
    value = calc_multa(cna, nil, Date.new(2015,11,22))
    assert_equal 267.23, value

  end

  test 'calc_juros' do
    cna = Cna.first
    _dt_ini = Date.new(2010,5,22)
    _dt_end = Date.new(2015,11,22)
    _new_value = calc_juros(cna, _dt_ini, _dt_end)

    assert_equal 125.98, _new_value

    cna = Cna.second
    _dt_end = Date.new(2015,11,22)
    _new_value = calc_juros(cna, nil, _dt_end)

    assert_equal 125.98, _new_value

  end

  test 'calc_cna' do
    skip
    cna = Cna.first
    _dt_ini = Date.new(2010,5,22)
    _dt_end = Date.new(2015,11,22)
    _value = calc_cna(cna, _dt_ini, _dt_end)
    assert_equal 584.09, _value
  end

end
