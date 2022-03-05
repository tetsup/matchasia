module Stripe
  class EventHandler
    def call(event)
      method = 'handle_' + event.type.tr('.', '_')
      send method, event
    rescue JSON::ParserError => e
      render json: { status: 400, error: 'Invalid payload' }
      Raven.capture_exception(e)
    rescue Stripe::SignatureVerificationError => e
      render json: { status: 400, error: 'Invalid Signeture' }
      Raven.capture_exception(e)
    end

    def handle_payment_intent_succeeded(event)
      Payment.from_event(event).extend_tickets!
    end
  end
end
