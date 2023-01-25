class OnboardController < ApplicationController
  before_action :set_survey

  def basics; end

  def personal; end

  def back
    redirect_to (set_onboard_path(params[:destination]) || onboard_basics_path(survey_id: @survey.id))
  end

  def update
    if @survey.tap { |s| s.assign_attributes(survey_params) }.save
      redirect_to set_onboard_path(params[:next])
    else
      render params[:current].to_sym
    end
  end

  private

  def set_survey
    @survey = Current.account.surveys.find_by(id: params[:survey_id] || params[:id]) || Survey.new(account: Current.account)
  end

  def survey_params
    params.require(:survey).permit(:name, :person_name, :content, :position, :site, :survey_type, :avatar, :border_color,
    :counter_max, :rating_icon, :hide_image, :email_collect, :video_feedback_enabled,
    :trigger_type, :delay_time_number, :delay_time_interval, survey_trigger_urls_attributes: [:id, :url, :_destroy])
  end

  def set_onboard_path(next_param)
    case next_param
    when 'personal'
      onboard_personal_path(survey_id: @survey.id)
    when 'finalize'
      onboard_finalize_path(survey_id: @survey.id)
    when 'finished'
      survey_path(@survey)
    else
      root_path
    end
  end
end
