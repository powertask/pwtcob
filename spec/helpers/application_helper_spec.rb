require 'rails_helper'

# Specs in this file have access to a helper object that includes
# the LawyersHelper. For example:
#
# describe LawyersHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       expect(helper.concat_strings("this","that")).to eq("this that")
#     end
#   end
# end
RSpec.describe ApplicationHelper, type: :helper do
  describe "Method calc_months()" do
    it "return months after 05/2015" do
      expect(calc_months(2010)).to eq(66)
    end
  end

  describe "Method calc_multa()" do
    it "return amount" do
      skip
      cna = Cna.Create!(
        unit_id: 1, amount: 134.09, )
      expect(calc_multa(cna)).to eq(6)
    end
  end


end
