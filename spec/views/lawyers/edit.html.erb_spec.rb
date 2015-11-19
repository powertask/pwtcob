require 'rails_helper'

RSpec.describe "lawyers/edit", type: :view do
  
  let(:unit) { FactoryGirl.create(:unit) }
  
  before(:each) do
    @lawyer = assign(:lawyer, Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => unit.id,
      :lawyer_code => "123",
      :cpf => "69806594053",
      :phone => "9560-1340",
      :zipcode => "90830-244",
      :address => "Rua Wilson A Freitas de Paiva",
      :state => "RS",
      :city => "Porto Alegre",
      :complement => "Ap201",
      :neighborhood => "Cavalhada",
      :email => "marcelo@powertask.com.br"
    ))
  end

  it "renders the edit lawyer form" do
    render

    assert_select "form[action=?][method=?]", lawyer_path(@lawyer), "post" do

      assert_select "input#lawyer_name[name=?]", "lawyer[name]"

      assert_select "input#lawyer_lawyer_code[name=?]", "lawyer[lawyer_code]"

      assert_select "input#lawyer_cpf[name=?]", "lawyer[cpf]"

      assert_select "input#lawyer_cnpj[name=?]", "lawyer[cnpj]"

      assert_select "input#lawyer_phone[name=?]", "lawyer[phone]"

      assert_select "input#lawyer_zipcode[name=?]", "lawyer[zipcode]"

      assert_select "input#lawyer_address[name=?]", "lawyer[address]"

      assert_select "input#lawyer_state[name=?]", "lawyer[state]"

      assert_select "input#lawyer_city[name=?]", "lawyer[city]"

      assert_select "input#lawyer_complement[name=?]", "lawyer[complement]"

      assert_select "input#lawyer_neighborhood[name=?]", "lawyer[neighborhood]"

      assert_select "input#lawyer_email[name=?]", "lawyer[email]"
    end
  end
end
