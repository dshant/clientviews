class Surveys::NotificationsController < ApplicationController
  def index
    @survey = Survey.find(params[:survey_id])
    begin
      if Current.account.slack.present?
        client = Slack::Web::Client.new(token: Current.account.slack.settings.dig('access_token'))
        @channels = client.conversations_list(exclude_archived: true, type: 'public_channel,private_channel').channels
      end
    rescue Slack::Web::Api::Errors::InvalidAuth
      @slack_auth_error = true
    rescue Slack::Web::Api::Errors => e
      Rails.logger.error "Slack Error: #{e.message}"
      @slack_errors = true
    end
  end

  def create
    @survey = Survey.find(params[:survey_id])
    if @survey.update(survey_params)
      msg = {success: 'Notification Settings were updated'}
    else
      msg = {warning: 'Notification Settings were unable to be saved'}
    end
    redirect_to survey_notifications_path(@survey), flash: msg
  end

  def slack_delete
    @survey = Survey.find(params[:survey_id])
    client = Slack::Web::Client.new(token: Current.account.slack.settings.dig('access_token'))
    env_symbol = Rails.env.production? ? :production : :development

    client.apps_uninstall(
      client_id: Rails.application.credentials[:slack][env_symbol][:client_id],
      client_secret: Rails.application.credentials[:slack][env_symbol][:client_secret]
    )
    if Current.account.slack.destroy
      msg = {success: 'Slack connection has been deleted'}
    else
      msg = {warning: 'Slack could not be deleted from the account. Contact Support'}
    end
    redirect_to survey_notifications_path(@survey), flash: msg
  end

  private

  def survey_params
    params.require(:survey).permit(:notification_slack_channel, survey_notification_emails_attributes: [:id, :email, :_destroy])
  end

end
