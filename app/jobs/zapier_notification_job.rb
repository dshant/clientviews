class ZapierNotificationJob < ApplicationJob
  queue_as :default

  def perform(response)
    data = {
      id: response.id,
      value: response.value,
      email: response.email,
      extra_text: response.extra_text
    }

    response&.survey&.zaps.each do |zap|
      ZapierSendJob.perform_later(zap.hook_url, data)
    end
  end

  

end
