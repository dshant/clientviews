class SurveysController < ApplicationController
  skip_before_action :authenticate_user!, only: [:thanks, :public]

  def show
    @survey = Survey.find(params[:id])
  end

  def thanks
    @survey = Survey.find(params[:id])
    render layout: 'layouts/public'
  end

  def public
    @survey = Survey.find(params[:id])
    render layout: 'layouts/public'
  end

  def preview

    if params[:id] && !params[:id].blank? && !params[:id].include?('new')
      db_survey = Survey.find_by(id: params[:id].split("survey_").last)
      @survey = if params[:survey].present?
        Survey.new(db_survey.attributes.merge(survey_params))
      else
        db_survey
      end
    else
      s_params = params[:survey].present? ? survey_params : {}
      @survey = Survey.new(s_params.merge(account: current_user.account))
    end

    puts "Survey: #{@survey.inspect}"

    render 'surveys/show'
  end

  def new
    redirect_back(fallback_location: root_path, flash: {warning: 'You have met your survey limit under this plan. Please delete a survey or upgrade your plan'}) if (Current.account.surveys.size >= Current.account.limits.surveys)
    @survey = Survey.new
  end

  def create
    @survey = Survey.new(survey_params)
    @survey.account = current_user&.account
    if @survey.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @survey = Survey.find(params[:id])
  end

  def update
    @survey = Survey.find(params[:id])
    if @survey.update(survey_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    @survey = Survey.find(params[:id])

    @survey.destroy

    redirect_back(fallback_location: root_path)
  end

  private

  def survey_params
    params.require(:survey).permit(
      :name, :person_name, :content, :position, :site, :survey_type, :avatar, :border_color,
      :counter_max, :rating_icon, :hide_image, :email_collect, :video_feedback_enabled,
      :trigger_type, :delay_time_number, :delay_time_interval, survey_trigger_urls_attributes: [:id, :url, :_destroy]
    )
  end
end
