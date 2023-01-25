ENV_STRIPE = Rails.env.production? ? :production : :staging
ENV_SYMBOL = Rails.env.production? ? :live : :test

Rails.configuration.stripe = {
  publishable_key: Rails.application.credentials[:stripe][ENV_SYMBOL][:pk],
  secret_key: Rails.application.credentials[:stripe][ENV_SYMBOL][:sk]
}

Stripe.api_key = Rails.application.credentials[:stripe][ENV_SYMBOL][:sk]
Stripe.api_version = '2020-08-27'
StripeEvent.signing_secret = Rails.application.credentials[:stripe][ENV_SYMBOL][:webhook] # e.g. whsec_...

StripeEvent.configure do |events|
  events.subscribe 'customer.', StripeSubscriptionUpdate.new
end
