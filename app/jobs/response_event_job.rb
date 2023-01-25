class ResponseEventJob < ApplicationJob
  queue_as :default

  def perform(response)
    puts "Response Event for response: #{response.id}"
    emails = [response.survey.account.users.order(created_at: :asc).first.email] | (response.survey.survey_notification_emails.pluck(:email) || [])
    emails.each do |email|
      ResponseNotificationMailer.with(response: response, email: email).notification_email.deliver_later
    end
    SlackNotificationJob.perform_later(response) if response.survey.account.slack.present? && response.survey.notification_slack_channel.present?
    ZapierNotificationJob.perform_later(response) if response.survey.zaps.present?
    WebhookManagerJob.perform_later(response) if response.survey.webhooks.present?
  end
end
