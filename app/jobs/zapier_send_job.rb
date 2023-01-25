class ZapierSendJob < ApplicationJob
  queue_as :default

  def perform(url_hook, data)
    response = HTTP.post(url_hook, json: data)
  end

  

end