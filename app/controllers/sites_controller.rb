class SitesController < ApplicationController
  def new
    @site = Site.new
  end

  def create
    @site = current_user.account.sites.new(site_params)
    if @site.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @site = Site.find(params[:id])
  end

  def update
    @site = Site.find(params[:id])
    if @site.update(site_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  private

  def site_params
    params.require(:site).permit(:domain)
  end
end
