class Events::MuxController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def create
    event_type = params[:type]
    data = params[:data]

    asset = VideoAsset.find_by(provider_asset_id: data[:id])

    if asset
      asset.update(status: data[:status], playback_id: data.dig(:playback_ids)&.first&.dig(:id))
    end

  end
end
