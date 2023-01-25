class Surveys::ResponsesController < ApplicationController
  def index
    @survey = Survey.find(params[:survey_id])
    @responses = Response.includes(:video_asset, :survey).where(survey_id: @survey).order(created_at: :desc)
    if params[:view] == "conversations"
      @responses = @responses.where.not(email: [nil, ""])
    elsif params[:view] == "no_info"
      @responses = @responses.where(email: [nil, ""])
    end
    @pagy = pagy(@responses).first

  end

end
