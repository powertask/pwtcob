require 'rails_helper'

RSpec.describe "lawyers/show", type: :view do
  before(:each) do
    @lawyer = assign(:lawyer, Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => 1,
      :lawyer_code => "123",
      :cpf => "69806594053"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Nome do Advogado/)
  end
end
