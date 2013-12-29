require "spec_helper"

describe AlumnisController do
  describe "routing" do

    it "routes to #index" do
      get("/alumnis").should route_to("alumnis#index")
    end

    it "routes to #new" do
      get("/alumnis/new").should route_to("alumnis#new")
    end

    it "routes to #show" do
      get("/alumnis/1").should route_to("alumnis#show", :id => "1")
    end

    it "routes to #edit" do
      get("/alumnis/1/edit").should route_to("alumnis#edit", :id => "1")
    end

    it "routes to #create" do
      post("/alumnis").should route_to("alumnis#create")
    end

    it "routes to #update" do
      put("/alumnis/1").should route_to("alumnis#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/alumnis/1").should route_to("alumnis#destroy", :id => "1")
    end

  end
end
