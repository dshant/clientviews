json.call(@survey, :id, :header, :image, :name, :person_name, :position,
  :hide_image, :email_collect, :survey_type, :border_color,
  :rating_icon, :counter_max, :thank_you_note
)
json.body @survey.content.body
json.video_feedback_enabled(
  @survey.account.plan.video &&
    ActiveModel::Type::Boolean.new.cast(@survey.video_feedback_enabled)
)
json.video_limit @survey.account.plan.video_time
json.avatar(
  if @survey.avatar.attached?
    if Rails.env.development?

      Rails.application.routes.url_helpers.rails_blob_path(Survey.last.avatar, only_path: true)
    else
      @survey.avatar.service.send(:object_for, @survey.avatar.key).public_url
    end
    # @survey.avatar.url
    # Rails.application.routes.url_helpers.rails_representation_url(@survey.avatar.variant(resize_to_limit: [144, 144]).processed, only_path: true)
  else
    @survey.image
  end
)
json.action api_v1_survey_responses_url([@survey], public: params[:public])
json.video_token DUC.encrypt_and_sign('amazon.Response#video_feedback_data')
json.r_url root_url
json.du_url rails_direct_uploads_url
json.enabled_to_show(
  case @survey.trigger_type
  when 'none'
    {type: 'none'}
  when 'delay'
    {
      type: 'delay',
      delay_s: (@survey.delay_time_number.send(@survey.delay_time_interval)).to_i
    }
  when 'url'
    visits_eh = ((Visit.where(visitor_token: params[:visitorId], survey_id: @survey_id).pluck(:full_location) || []) & @survey.survey_trigger_urls.pluck(:url)).empty?
    {
      type: 'url',
      show: visits_eh
    }
  end
)
