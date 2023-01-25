class WebhookManagerJob < ApplicationJob
  queue_as :default

  def perform(response)
    data = {
      id: response.id,
      value: response.value,
      email: response.email,
      extra_text: response.extra_text
    }

    response&.survey&.webhooks.each do |wh|
      WebhookSendJob.perform_later(wh, data)
    end
  end

  

end
