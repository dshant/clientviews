class Admin::AdminController < ApplicationController

  def info
    unless params[:user_id].blank?
      @user = User.find(params[:user_id])
    end
  end
end
