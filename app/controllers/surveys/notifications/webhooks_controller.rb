class Surveys::Notifications::WebhooksController < ApplicationController
  def new
    survey = Survey.find(params[:survey_id])
    @webhook = survey.webhooks.new
  end

  def create
    survey = Survey.find(params[:survey_id])
    @webhook = survey.webhooks.new(webhook_params)
    if @webhook.save
      redirect_to survey_notifications_path(@webhook.survey), flash: {success: 'Created Webhook'}
    else
      render :new
    end
  end

  def edit
    @webhook = SurveyResponseWebhook.find(params[:id])
  end

  def update
    @webhook = SurveyResponseWebhook.find(params[:id])
    if @webhook.update(webhook_params)
      redirect_to survey_notifications_path(@webhook.survey), flash: {success: 'Updated Webhook'}
    else
      render :edit
    end
  end

  def destroy
    @webhook = SurveyResponseWebhook.find(params[:id])

    @webhook.destroy

    redirect_to survey_notifications_path(@webhook.survey), flash: {success: 'Removed Webhook'}
  end

  private

  def webhook_params
    params.require(:survey_response_webhook).permit(:name, :url, :token)
  end

end
