require 'rails_helper'

RSpec.describe "lawyers/index", type: :view do

  let(:unit1) { FactoryGirl.create(:unit) }
  let(:unit2) { FactoryGirl.create(:unit2, name: "Unit 2") }

  before(:each) do
    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => unit1.id,
      :lawyer_code => "123",
      :cpf => "69806594053"
      )
    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => unit1.id,
      :lawyer_code => "123",
      :cpf => "69806594053"
    )
    Lawyer.create!(
      :name => "Marcelo Reichert",
      :unit_id => unit2.id,
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
