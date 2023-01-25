class Events::SegmentController < ApplicationController
  skip_before_action :authenticate_user!
  protect_from_forgery with: :null_session

  def create
    event_type = params[:type]
    data = params[:data]

    render json: { }, status: 202

  end
end