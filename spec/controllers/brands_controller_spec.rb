require 'rails_helper'

RSpec.describe BrandsController, type: :controller do
  let(:valid_attributes) {
    {
      name: Faker::Team.name
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
    it "assigns all brands as @brands" do
      brand = Brand.create! valid_attributes
        get :index, params: {}
      expect(assigns(:brands)).to eq([brand])
    end
  end

  describe "GET #show" do
    it "assigns the requested brand as @brand" do
      brand = Brand.create! valid_attributes
        get :show, params: {id: brand.to_param}
      expect(assigns(:brand)).to eq(brand)
    end
  end

  describe "GET #new" do
    it "assigns a new brand as @brand" do
        get :new, params: {}
      expect(assigns(:brand)).to be_a_new(Brand)
    end
  end

  describe "GET #edit" do
    it "assigns the requested brand as @brand" do
      brand = Brand.create! valid_attributes
        get :edit, params: {id: brand.to_param}
      expect(assigns(:brand)).to eq(brand)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new Brand" do
        expect {
            post :create, params: {brand: valid_attributes}
        }.to change(Brand, :count).by(1)
      end

      it "assigns a newly created brand as @brand" do
          post :create, params: {brand: valid_attributes}
        expect(assigns(:brand)).to be_a(Brand)
        expect(assigns(:brand)).to be_persisted
      end

      it "redirects to the created brand" do
          post :create, params: {brand: valid_attributes}
        expect(response).to redirect_to(brands_path)
      end
    end

    context "with invalid params" do
      it "assigns a newly created but unsaved brand as @brand" do
          post :create, params: {brand: invalid_attributes}
        expect(assigns(:brand)).to be_a_new(Brand)
      end

      it "re-renders the 'new' template" do
          post :create, params: {brand: invalid_attributes}
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT #update" do
    context "with valid params" do
      let(:new_attributes) {
        skip("Add a hash of attributes valid for your model")
      }

      it "updates the requested brand" do
        brand = Brand.create! valid_attributes
          put :update, params: {id: brand.to_param, brand: new_attributes}
        brand.reload
        skip("Add assertions for updated state")
      end

      it "assigns the requested brand as @brand" do
        brand = Brand.create! valid_attributes
          put :update, params: {id: brand.to_param, brand: valid_attributes}
        expect(assigns(:brand)).to eq(brand)
      end

      it "redirects to the brand" do
        brand = Brand.create! valid_attributes
          put :update, params: {id: brand.to_param, brand: valid_attributes}
        expect(response).to redirect_to(brands_path)
      end
    end

    context "with invalid params" do
      it "assigns the brand as @brand" do
        brand = Brand.create! valid_attributes
          put :update, params: {id: brand.to_param, brand: invalid_attributes}
        expect(assigns(:brand)).to eq(brand)
      end

      it "re-renders the 'edit' template" do
        brand = Brand.create! valid_attributes
          put :update, params: {id: brand.to_param, brand: invalid_attributes}
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested brand" do
      brand = Brand.create! valid_attributes
      expect {
          delete :destroy, params: {id: brand.to_param}
      }.to change(Brand, :count).by(-1)
    end

    it "redirects to the brands list" do
      brand = Brand.create! valid_attributes
        delete :destroy, params: {id: brand.to_param}
      expect(response).to redirect_to(brands_url)
    end
  end

end
