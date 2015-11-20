require 'rails_helper'

RSpec.describe LawyersController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Lawyer. As you add validations to Lawyer, be sure to
  # adjust the attributes here as well.
  let(:unit) { FactoryGirl.create(:unit) }

  let(:valid_attributes) {
    {name: "Marcelo Reichert", unit_id: unit.id, lawyer_code: 1, cpf: "69806594053"}
  }

  let(:invalid_attributes) {
    {name: "Marcelo Reichert", unit_id: nil, cpf: 999 }
  }


  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # LawyersController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  before :each do
    sign_in
    session[:unit_id] = 1
  end

  describe "GET #index" do
    it "assigns all lawyers as @lawyers" do
      lawyer = Lawyer.create! valid_attributes
      get :index, {:unit_id => 1}, valid_session
      expect(assigns(:lawyers)).to eq([lawyer])
    end
  end

  describe "GET #show" do
    it "assigns the requested lawyer as @lawyer" do
      lawyer = Lawyer.create! valid_attributes
      get :show, {:id => lawyer.to_param}, valid_session
      expect(assigns(:lawyer)).to eq(lawyer)
    end
  end

  describe "GET #new" do
    it "assigns a new lawyer as @lawyer" do
      get :new, {}, valid_session
      expect(assigns(:lawyer)).to be_a_new(Lawyer)
    end
  end

  describe "GET #edit" do
    it "assigns the requested lawyer as @lawyer" do
      lawyer = Lawyer.create! valid_attributes
      get :edit, {:id => lawyer.to_param}, valid_session
      expect(assigns(:lawyer)).to eq(lawyer)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Lawyer" do
        expect {
          post :create, {:lawyer => valid_attributes}, valid_session
        }.to change(Lawyer, :count).by(1)
      end

      it "assigns a newly created lawyer as @lawyer" do
        post :create, {:lawyer => valid_attributes}, valid_session
        expect(assigns(:lawyer)).to be_a(Lawyer)
        expect(assigns(:lawyer)).to be_persisted
      end

      it "redirects to the created lawyer" do
        post :create, {:lawyer => valid_attributes}, valid_session
        expect(response).to redirect_to(Lawyer.last)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved lawyer as @lawyer" do
        post :create, {:lawyer => invalid_attributes}, valid_session
        expect(assigns(:lawyer)).to be_a_new(Lawyer)
      end

      it "re-renders the 'new' template" do
        post :create, {:lawyer => invalid_attributes}, valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        { name: "Marcelo Reichert", unit_id: 1, lawyer_code: 1, cpf: "69806594053" }
      }

      it "updates the requested lawyer" do
        lawyer = Lawyer.create! valid_attributes
        put :update, {:id => lawyer.to_param, :lawyer => new_attributes}, valid_session
        lawyer.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested lawyer as @lawyer" do
        lawyer = Lawyer.create! valid_attributes
        put :update, {:id => lawyer.to_param, :lawyer => valid_attributes}, valid_session
        expect(assigns(:lawyer)).to eq(lawyer)
      end

      it "redirects to the lawyer" do
        lawyer = Lawyer.create! valid_attributes
        put :update, {:id => lawyer.to_param, :lawyer => valid_attributes}, valid_session
        expect(response).to redirect_to(lawyer)
      end
    end

    context "with invalid params" do
      it "assigns the lawyer as @lawyer" do
        lawyer = Lawyer.create! valid_attributes
        put :update, {:id => lawyer.to_param, :lawyer => invalid_attributes}, valid_session
        expect(assigns(:lawyer)).to eq(lawyer)
      end

      it "re-renders the 'edit' template" do
        lawyer = Lawyer.create! valid_attributes
        put :update, {:id => lawyer.to_param, :lawyer => invalid_attributes}, valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested lawyer" do
      lawyer = Lawyer.create! valid_attributes
      expect {
        delete :destroy, {:id => lawyer.to_param}, valid_session
      }.to change(Lawyer, :count).by(-1)
    end

    it "redirects to the lawyers list" do
      lawyer = Lawyer.create! valid_attributes
      delete :destroy, {:id => lawyer.to_param}, valid_session
      expect(response).to redirect_to(lawyers_url)
    end
  end

end
