require 'rails_helper'

RSpec.describe "cities/index", type: :view do
  before(:each) do
    assign(:cities, [
      City.create!(
        :name => "Name",
        :status => 1,
        :state => "State"
      ),
      City.create!(
        :name => "Name",
        :status => 1,
        :state => "State"
      )
    ])
  end

  it "renders a list of cities" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
  end
end
