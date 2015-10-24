require 'rails_helper'

RSpec.describe "lawyers/show", type: :view do
  before(:each) do
    @lawyer = assign(:lawyer, Lawyer.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Lawyer_code/)
    expect(rendered).to match(/Cpf/)
    expect(rendered).to match(/Cnpj/)
    expect(rendered).to match(/Phone/)
    expect(rendered).to match(/Zipcode/)
    expect(rendered).to match(/Address/)
    expect(rendered).to match(/State/)
    expect(rendered).to match(/City/)
    expect(rendered).to match(/Complement/)
    expect(rendered).to match(/Neighborhood/)
    expect(rendered).to match(/Email/)
  end
end
