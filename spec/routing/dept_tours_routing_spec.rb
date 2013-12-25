require "spec_helper"

describe DeptToursController do
  describe "routing" do

    it "routes to #index" do
      get("/dept_tours").should route_to("dept_tours#index")
    end

    it "routes to #new" do
      get("/dept_tours/new").should route_to("dept_tours#new")
    end

    it "routes to #show" do
      get("/dept_tours/1").should route_to("dept_tours#show", :id => "1")
    end

    it "routes to #edit" do
      get("/dept_tours/1/edit").should route_to("dept_tours#edit", :id => "1")
    end

    it "routes to #create" do
      post("/dept_tours").should route_to("dept_tours#create")
    end

    it "routes to #update" do
      put("/dept_tours/1").should route_to("dept_tours#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/dept_tours/1").should route_to("dept_tours#destroy", :id => "1")
    end

  end
end
