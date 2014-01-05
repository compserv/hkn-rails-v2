require 'spec_helper'

describe Admin::BridgeController do

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      response.should be_success
    end
  end

  describe "GET 'officer_photo_upload'" do
    it "returns http success" do
      get 'officer_photo_upload'
      response.should be_success
    end
  end

end
