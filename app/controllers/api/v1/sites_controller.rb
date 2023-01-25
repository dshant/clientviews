class Api::V1::SitesController < Api::BaseController
  def show
    @site = Site.by_url(params[:id])
    if @site.present?
      render 'sites/show'
    else
      render json: { error: 'Site not registered' }
    end
  end
end
