class Admin::IndrelController < ApplicationController
  before_filter :authenticate_indrel!

  def index
  end
end
