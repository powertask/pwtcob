require 'rails_helper'

RSpec.describe "lawyers/edit", type: :view do
  before(:each) do
    @lawyer = assign(:lawyer, Lawyer.create!(
      :name => "MyString",
      :lawyer_code => "MyString",
      :cpf => "MyString",
      :cnpj => "MyString",
      :phone => "MyString",
      :zipcode => "MyString",
      :address => "MyString",
      :state => "MyString",
      :city => "MyString",
      :complement => "MyString",
      :neighborhood => "MyString",
      :email => "MyString"
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
