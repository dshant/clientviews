class AdminController < ApplicationController

  def index
    unless params[:user_id].blank?
      @user = User.find(params[:user_id])
    end
  end
end
