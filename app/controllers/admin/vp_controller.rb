class Admin::VpController < ApplicationController
  before_filter :authenticate_vp!

  def index
  end
end
