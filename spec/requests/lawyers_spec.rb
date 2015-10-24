require 'rails_helper'

RSpec.describe "Lawyers", type: :request do
  describe "GET /lawyers" do
    it "works! (now write some real specs)" do
      get lawyers_path
      expect(response).to have_http_status(200)
    end
  end
end
