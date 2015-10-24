require 'rails_helper'

RSpec.describe "lawyers/index", type: :view do
  before(:each) do
    assign(:lawyers, [
      Lawyer.create!(
        :name => "Name",
        :lawyer_code => "Lawyer_code",
        :cpf => "Cpf",
        :cnpj => "Cnpj",
        :phone => "Phone",
        :zipcode => "Zipcode",
        :address => "Address",
        :state => "State",
        :city => "City",
        :complement => "Complement",
        :neighborhood => "Neighborhood",
        :email => "Email"
      ),
      Lawyer.create!(
        :name => "Name",
        :lawyer_code => "Lawyer_code",
        :cpf => "Cpf",
        :cnpj => "Cnpj",
        :phone => "Phone",
        :zipcode => "Zipcode",
        :address => "Address",
        :state => "State",
        :city => "City",
        :complement => "Complement",
        :neighborhood => "Neighborhood",
        :email => "Email"
      )
    ])
  end

  it "renders a list of lawyers" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Lawyer_code".to_s, :count => 2
    assert_select "tr>td", :text => "Cpf".to_s, :count => 2
    assert_select "tr>td", :text => "Cnpj".to_s, :count => 2
    assert_select "tr>td", :text => "Phone".to_s, :count => 2
    assert_select "tr>td", :text => "Zipcode".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "Complement".to_s, :count => 2
    assert_select "tr>td", :text => "Neighborhood".to_s, :count => 2
    assert_select "tr>td", :text => "Email".to_s, :count => 2
  end
end
