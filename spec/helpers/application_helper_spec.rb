require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do

  let(:cna) { FactoryGirl.create(:cna_1) }

  describe "calc_meses_atraso()" do
    it "return months after 05/2010" do
      expect(calc_meses_atraso(cna)).to eq(66)
    end
  end

  describe "calc_multa()" do
    it "return multa" do
      expect(calc_multa(cna)).to eq(267.23)
    end
  end

  describe "calc_valor_corrigido_INPC()" do
    it "return valor corrigido" do
      expect(calc_valor_corrigido_INPC(cna)).to eq(190.88)
    end
  end

  describe "calc_juros()" do
    it "return juros" do
      expect(calc_juros(cna)).to eq(125.98)
    end
  end


end
