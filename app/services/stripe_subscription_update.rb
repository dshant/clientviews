class StripeSubscriptionUpdate

  def call(event)
    StripeSubscriptionUpdateJob.perform_later(event.id)
  end

end
