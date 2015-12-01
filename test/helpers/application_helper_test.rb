require 'test_helper'
 
class ApplicationHelperTest < ActiveSupport::TestCase
  include ApplicationHelper
  
  test "meses em atraso" do
  	_dt_ini = Date.new(2010,5,22)
  	_dt_end = Date.new(2015,11,22)
    _meses_atraso = calc_meses_atraso(_dt_ini, _dt_end)
    assert_equal 66, _meses_atraso
  end

  test 'calc_valor_corrigido_INPC' do
    skip
  	_dt_ini = Date.new(2010,5,22)
  	_dt_end = Date.new(2015,11,22)
  	_value = 134.09

  	_new_value = calc_valor_corrigido_INPC(_dt_ini, _dt_end, _value)

  	assert_equal 190.88, _new_value
  end

  test 'calc_multa' do
  	_value = calc_multa(Date.new(2010,5,22), Date.new(2015,11,22), 190.88)

  	assert_equal 267.23, _value
  end

  test 'calc_juros' do
    _dt_ini = Date.new(2010,5,22)
    _dt_end = Date.new(2015,11,22)
    _value = 190.88

    _new_value = calc_juros(_dt_ini, _dt_end, _value)

    assert_equal 125.98, _new_value
  end

  test 'calc_cna' do
    skip
    cna = Cna.find 1
    _value = calc_cna(cna)
    assert_equal 584.09, _value
  end

end
