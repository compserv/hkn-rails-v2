require 'spec_helper'

describe Admin::CsecController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'select_classes'" do
    it "returns http success" do
      get 'select_classes'
      response.should be_success
    end
  end

  describe "GET 'manage_classes'" do
    it "returns http success" do
      get 'manage_classes'
      response.should be_success
    end
  end

  describe "GET 'manage_candidates'" do
    it "returns http success" do
      get 'manage_candidates'
      response.should be_success
    end
  end

  describe "GET 'upload_surveys'" do
    it "returns http success" do
      get 'upload_surveys'
      response.should be_success
    end
  end

end
