FactoryBot.define do
  factory :reservation do
    association :student
    association :lesson
    start_url { 'https://example.com/123456' }
    join_url { 'https://example.com/113355779' }
  end
end
