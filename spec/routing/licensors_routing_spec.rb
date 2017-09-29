require "rails_helper"

RSpec.describe LicensorsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/licensors").to route_to("licensors#index")
    end

    it "routes to #new" do
      expect(:get => "/licensors/new").to route_to("licensors#new")
    end

    it "routes to #show" do
      expect(:get => "/licensors/1").to route_to("licensors#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/licensors/1/edit").to route_to("licensors#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/licensors").to route_to("licensors#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/licensors/1").to route_to("licensors#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/licensors/1").to route_to("licensors#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/licensors/1").to route_to("licensors#destroy", :id => "1")
    end

  end
end
