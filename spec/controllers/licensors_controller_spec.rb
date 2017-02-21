require 'rails_helper'

RSpec.describe LicensorsController, type: :controller do

  # This should return the minimal set of attributes required to create a valid
  # Licensor. As you add validations to Licensor, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) {
    {
      name: Faker::Company.name
    }
  }

  let(:invalid_attributes) {
    {
      name: ""
    }
  }

  before(:each) do
    login_user
  end

  describe "GET #index" do
    it "assigns all licensors as @licensors" do
      licensor = Licensor.create! valid_attributes
      get :index, params: {}
      expect(assigns(:licensors)).to eq([licensor])
    end
  end

  describe "GET #show" do
    it "assigns the requested licensor as @licensor" do
      licensor = Licensor.create! valid_attributes
      get :show, params: {id: licensor.to_param}
      expect(assigns(:licensor)).to eq(licensor)
    end
  end

  describe "GET #new" do
    it "assigns a new licensor as @licensor" do
      get :new, params: {}
      expect(assigns(:licensor)).to be_a_new(Licensor)
    end
  end

  describe "GET #edit" do
    it "assigns the requested licensor as @licensor" do
      licensor = Licensor.create! valid_attributes
      get :edit, params: {id: licensor.to_param}
      expect(assigns(:licensor)).to eq(licensor)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Licensor" do
        expect {
          post :create, params: {licensor: valid_attributes}
        }.to change(Licensor, :count).by(1)
      end

      it "assigns a newly created licensor as @licensor" do
        post :create, params: {licensor: valid_attributes}
        expect(assigns(:licensor)).to be_a(Licensor)
        expect(assigns(:licensor)).to be_persisted
      end

      it "redirects to the created licensor" do
        post :create, params: {licensor: valid_attributes}
        expect(response).to redirect_to(licensors_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved licensor as @licensor" do
        post :create, params: {licensor: invalid_attributes}
        expect(assigns(:licensor)).to be_a_new(Licensor)
      end

      it "re-renders the 'new' template" do
        post :create, params: {licensor: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested licensor" do
        licensor = Licensor.create! valid_attributes
        put :update, params: {id: licensor.to_param, licensor: new_attributes}
        licensor.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested licensor as @licensor" do
        licensor = Licensor.create! valid_attributes
        put :update, params: {id: licensor.to_param, licensor: valid_attributes}
        expect(assigns(:licensor)).to eq(licensor)
      end

      it "redirects to the licensor" do
        licensor = Licensor.create! valid_attributes
        put :update, params: {id: licensor.to_param, licensor: valid_attributes}
        expect(response).to redirect_to(licensors_path)
      end
    end

    context "with invalid params" do
      it "assigns the licensor as @licensor" do
        licensor = Licensor.create! valid_attributes
        put :update, params: {id: licensor.to_param, licensor: invalid_attributes}
        expect(assigns(:licensor)).to eq(licensor)
      end

      it "re-renders the 'edit' template" do
        licensor = Licensor.create! valid_attributes
        put :update, params: {id: licensor.to_param, licensor: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested licensor" do
      licensor = Licensor.create! valid_attributes
      expect {
        delete :destroy, params: {id: licensor.to_param}
      }.to change(Licensor, :count).by(-1)
    end

    it "redirects to the licensors list" do
      licensor = Licensor.create! valid_attributes
      delete :destroy, params: {id: licensor.to_param}
      expect(response).to redirect_to(licensors_url)
    end
  end

end
