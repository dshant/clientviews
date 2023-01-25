class IdentifyJob < ApplicationJob
  queue_as :default

  def perform(user, yoha_id)
    return unless Rails.env.production?

    puts "Identify: #{yoha_id}, #{user.inspect}"
    return if yoha_id.blank?

    VisitorIdentity.find_or_initialize_by(visitor_token: yoha_id).tap do |vi|
      vi.email = user.email
      vi.uid = user.id
      vi.account = { id: user.account.id } unless user&.account.blank?
      vi.save
    end

    Segment.identify(
      user_id: user.id,
      traits: { email: user.email.to_s },
      context: {}
    )

    Segment.track(
      user_id: user.id,
      event: 'Visit'
    )
  end
end
