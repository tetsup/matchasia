FactoryBot.define do
  factory :report do
    association :lesson, :started_last_hour
    content { 'lecture below:\ngreeting' }
  end
end
