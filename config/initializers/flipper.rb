# adapter = Flipper::Adapters::ActiveRecord.new
# FLIPPER = Flipper.new(adapter)

class CanAccessFlipperUI
  def self.matches?(request)
    return true unless Rails.env.production?
    current_user = request.env['warden'].user
    current_user.present? && (current_user.email == 'rob.race@me.com' || current_user.email == 'rob@inbound.to' || current_user.email == 'rob@userveys.com')
  end
end
