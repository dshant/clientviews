require 'sinatra'
require 'json'
use Rack::CommonLogger

class WHA < Sinatra::Base

  configure do
    enable :logging
  end

  post '/webhooks' do
    request.body.rewind
    payload_body = request.body.read
    # verify_signature(payload_body)
    JSON.parse(payload_body)
    status = case rand(10) ## 30%/30%/40%
            when 5, 7, 9
              503
            when 2, 4, 6
              401
            else
              200
            end
    [status, {}, '']
  end

  def verify_signature(payload)
    token = payload['message_id'] + payload['to'] + payload['from'] + payload['subject'] + payload['date']
    signature = OpenSSL::HMAC.hexdigest(
      'SHA256', 'd0693ca8-20ce-42cd-b3ca-ce36cfcdc876', token
    )
    return if Rack::Utils.secure_compare(
      signature, request.env['HTTP_X_INBOUND_SIGNATURE']
    )

    halt 500, "Signatures didn't match!"
  end
end