class Admin::StudrelController < ApplicationController
  before_filter :authenticate_studrel!

  def index
  end
end
