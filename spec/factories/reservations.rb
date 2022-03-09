FactoryBot.define do
  factory :reservation do
    association :student
    association :lesson
    start_url { 'https://example.com/123456' }
    join_url { 'https://example.com/113355779' }
    tickets_before { 1 }
    tickets_after { 0 }
    trait :continuous do
      sequence(:start_url, 'https://example.com/start/1')
      sequence(:join_url, 'https://example.com/join/1')
    end
  end
end
