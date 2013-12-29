require "spec_helper"

describe AlumniController do
  describe "routing" do

    it "routes to #index" do
      get("/alumni").should route_to("alumni#index")
    end

    it "routes to #new" do
      get("/alumni/new").should route_to("alumni#new")
    end

    it "routes to #show" do
      get("/alumni/1").should route_to("alumni#show", :id => "1")
    end

    it "routes to #edit" do
      get("/alumni/1/edit").should route_to("alumni#edit", :id => "1")
    end

    it "routes to #create" do
      post("/alumni").should route_to("alumni#create")
    end

    it "routes to #update" do
      put("/alumni/1").should route_to("alumni#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/alumni/1").should route_to("alumni#destroy", :id => "1")
    end

  end
end
