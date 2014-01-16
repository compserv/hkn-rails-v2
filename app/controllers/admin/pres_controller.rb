class Admin::PresController < ApplicationController
  before_filter :authenticate_pres!

  def index
  end
end
