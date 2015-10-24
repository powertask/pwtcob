require "rails_helper"

RSpec.describe LawyersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/lawyers").to route_to("lawyers#index")
    end

    it "routes to #new" do
      expect(:get => "/lawyers/new").to route_to("lawyers#new")
    end

    it "routes to #show" do
      expect(:get => "/lawyers/1").to route_to("lawyers#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/lawyers/1/edit").to route_to("lawyers#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/lawyers").to route_to("lawyers#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/lawyers/1").to route_to("lawyers#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/lawyers/1").to route_to("lawyers#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/lawyers/1").to route_to("lawyers#destroy", :id => "1")
    end

  end
end
