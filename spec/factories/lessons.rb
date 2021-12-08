FactoryBot.define do
  factory :lesson do
    association :teacher
    start_time { 1.hours.from_now.ceil_to(1.hours) }
    association :language

    trait :started_last_hour do
      start_time { 1.hours.ago.ceil_to(1.hours) }
    end

    trait :start_one_hour_later do
      start_time { 1.hours.from_now.ceil_to(1.hours) }
    end
  end
end
