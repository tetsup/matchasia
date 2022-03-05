Stripe.api_key = Rails.application.credentials.stripe[:secret_key]
Stripe.api_version = '2020-08-27'
StripeEvent.signing_secret = Rails.application.credentials.stripe[:webhook_secret]

StripeEvent.configure do |events|
  events.subscribe 'payment_intent.succeeded', Stripe::EventHandler.new
end
