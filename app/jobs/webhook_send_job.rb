class WebhookSendJob < ApplicationJob
  queue_as :default

  retry_on(HTTP::Error, HTTP::Request::UnsupportedSchemeError) do |job, ex| #, 
    puts "Error:\n"
    puts "OMG an Error #{ex.inspect}\n\n#{job.inspect}"
  end

  def perform(wh, data)
    response = HTTP.post(wh.url, json: data)
    puts "? #{response.status.success?}"
    raise HTTP::Error unless response.status.success?
  end

  

end