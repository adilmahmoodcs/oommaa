require "rails_helper"

RSpec.describe UsersController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/users").to route_to("users#index")
    end

    it "routes to #edit" do
      expect(:get => "/admin/users/1/edit").to route_to("users#edit", :id => "1")
    end

    it "routes to #update via PUT" do
      expect(:put => "/admin/users/1").to route_to("users#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/admin/users/1").to route_to("users#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/users/1").to route_to("users#destroy", :id => "1")
    end

  end
end
