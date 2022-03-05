FactoryBot.define do
  factory :payment do
    association :student
    price_id { 1 }
    payment_phase { :requested }

    trait :with_payment_intent do
      payment_intent { 'pi_dummy_intent_88888888' }
    end

    trait :price_three_tickets do
      with_payment_intent
      price_id { 2 }
    end

    trait :price_five_tickets do
      with_payment_intent
      price_id { 3 }
    end

    trait :already_extended do
      with_payment_intent
      payment_phase { :extended }
    end
  end
end
