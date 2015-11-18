require 'rails_helper'

RSpec.describe "lawyers/index", type: :view do
  before(:each) do
    Unit.create!(id: 2, name: "Unit 2")

    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => 1,
      :lawyer_code => "123",
      :cpf => "69806594053"
      )
    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => 1,
      :lawyer_code => "123",
      :cpf => "69806594053"
    )
    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => 2,
      :lawyer_code => "123",
      :cpf => "69806594053"
    )

    assign(:lawyers, Lawyer.list(1).paginate(:page => 1, :per_page => 50))

  end

  it "renders a list of lawyers" do
    render
    assert_select ".strip", :text => "123", :count => 2
  end
end
