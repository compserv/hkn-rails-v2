require "spec_helper"

describe StaffMembersController do
  describe "routing" do

    it "routes to #index" do
      get("/staff_members").should route_to("staff_members#index")
    end

    it "routes to #new" do
      get("/staff_members/new").should route_to("staff_members#new")
    end

    it "routes to #show" do
      get("/staff_members/1").should route_to("staff_members#show", :id => "1")
    end

    it "routes to #edit" do
      get("/staff_members/1/edit").should route_to("staff_members#edit", :id => "1")
    end

    it "routes to #create" do
      post("/staff_members").should route_to("staff_members#create")
    end

    it "routes to #update" do
      put("/staff_members/1").should route_to("staff_members#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/staff_members/1").should route_to("staff_members#destroy", :id => "1")
    end

  end
end
